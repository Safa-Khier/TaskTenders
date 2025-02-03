import * as admin from "firebase-admin";
import { GeoPoint } from "@google-cloud/firestore";
import { PriorityQueue } from "@datastructures-js/priority-queue"; // Efficient Min-Heap
// import { Storage } from "@google-cloud/storage";
import { onDocumentCreated } from "firebase-functions/v2/firestore";
import { onSchedule } from "firebase-functions/v2/scheduler";
import { setGlobalOptions } from "firebase-functions/v2/options";

import * as fs from "fs";


const serviceAccount = JSON.parse(fs.readFileSync(__dirname + "/tasktenders-1-firebase-adminsdk-k43td-5cb02e9f4d.json", "utf-8"));
admin.initializeApp({ credential: admin.credential.cert(serviceAccount), storageBucket: "gs://tasktenders-1.firebasestorage.app",   });

// const storage = new Storage({
//   keyFilename: __dirname + "/tasktenders-1-firebase-adminsdk-k43td-5cb02e9f4d.json",
// });
// const bucket = storage.bucket("gs://tasktenders-1.firebasestorage.app");

const db = admin.firestore();

interface User {
    uid: string;
    firstName: string;
    lastName: string;
    role: string;
    location: GeoPoint;
  }
  
  interface Job {
    id: string;
    userId: string;
    location: GeoPoint;
    status: string;
  }
  
/**
   * Calculates the distance between two coordinates using the Haversine formula.
   */
function haversineDistance(loc1: GeoPoint, loc2: GeoPoint): number {
  const toRad = (x: number) => (x * Math.PI) / 180;
  const R = 6371; // Earth's radius in km
  const dLat = toRad(loc2.latitude - loc1.latitude);
  const dLon = toRad(loc2.longitude - loc1.longitude);
  const lat1 = toRad(loc1.latitude);
  const lat2 = toRad(loc2.latitude);
  
  const a =
      Math.sin(dLat / 2) * Math.sin(dLat / 2) +
      Math.cos(lat1) * Math.cos(lat2) * Math.sin(dLon / 2) * Math.sin(dLon / 2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  return R * c; // Distance in km
}
  
/**
   * Firebase Function to optimally match taskers to jobs.
   */
export async function matchTaskersToJobs() {
  console.log("Starting optimized tasker-job matching...");
  const startTime = performance.now();

  // Fetch taskers (users with role 'tasker')
  const taskersSnapshot = await db.collection("users").where("role", "==", "tasker").get();
  const jobsSnapshot = await db.collection("jobs").where("status", "==", "open").get();

  console.log(`Taskers found: ${taskersSnapshot.size}`);
  console.log(`Jobs found: ${jobsSnapshot.size}`);

  if (taskersSnapshot.empty || jobsSnapshot.empty) {
    console.log("No taskers or jobs available for matching.");
    return;
  }

  let taskers: User[] = taskersSnapshot.docs.map((doc) => ({
    uid: doc.id,
    ...doc.data(),
  } as User));

  const jobs: Job[] = jobsSnapshot.docs.map((doc) => ({
    id: doc.id,
    ...doc.data(),
  } as Job));

  const maxJobsPerTasker = 3; // Limit jobs per tasker to prevent overload

  // ✅ Step 1: Create Min-Heap Based on Tasker Workload
  const taskerQueue = new PriorityQueue<{ tasker: User; workload: number; distance: number }>(
    (a, b) => a.workload - b.workload || a.distance - b.distance
  );

  const assignments = new Map<string, string>(); // jobId -> taskerId
  const taskerWorkload = new Map<string, number>(); // Track how many jobs each tasker has

  // ✅ Step 2: Populate Tasker Min-Heap
  taskers.forEach((tasker) => {
    taskerWorkload.set(tasker.uid, 0); // Initially, all taskers have 0 jobs assigned
  });

  // ✅ Step 3: Assign Jobs Using Min-Heap (Ensuring Even Distribution)
  for (const job of jobs) {
    taskerQueue.clear();

    for (const tasker of taskers) {
      const workload = taskerWorkload.get(tasker.uid)!;
      const distance = haversineDistance(job.location, tasker.location);
      taskerQueue.enqueue({ tasker, workload, distance });
    }

    if (!taskerQueue.isEmpty()) {
      const bestTaskerItem = taskerQueue.dequeue();
      if (!bestTaskerItem) continue;
      const bestTasker = bestTaskerItem.tasker;

      assignments.set(job.id, bestTasker.uid);
      taskerWorkload.set(bestTasker.uid, taskerWorkload.get(bestTasker.uid)! + 1);

      // Remove tasker if max job limit is reached
      if (taskerWorkload.get(bestTasker.uid)! >= maxJobsPerTasker) {
        taskers = taskers.filter((t) => t.uid !== bestTasker.uid);
      }
    }
  }

  // ✅ Step 4: Optimize Assignment via Local Swap (Reducing Travel Distance)
  for (const [jobId1, taskerId1] of assignments.entries()) {
    for (const [jobId2, taskerId2] of assignments.entries()) {
      if (jobId1 === jobId2 || taskerId1 === taskerId2) continue;

      const job1 = jobs.find((j) => j.id === jobId1)!;
      const job2 = jobs.find((j) => j.id === jobId2)!;
      const tasker1 = taskersSnapshot.docs.find((t) => t.id === taskerId1)!;
      const tasker2 = taskersSnapshot.docs.find((t) => t.id === taskerId2)!;

      const currentTotalDist =
          haversineDistance(job1.location, tasker1.data().location) +
          haversineDistance(job2.location, tasker2.data().location);
      const swappedTotalDist =
          haversineDistance(job1.location, tasker2.data().location) +
          haversineDistance(job2.location, tasker1.data().location);

      if (swappedTotalDist < currentTotalDist) {
        // Swap taskers if it reduces travel time
        assignments.set(jobId1, taskerId2);
        assignments.set(jobId2, taskerId1);
      }
    }
  }

  // console.log("Final Optimized Assignments:", assignments);

  // const jsonData = [];

  try {
    const batch = db.batch();

    for (const [jobId, taskerId] of assignments.entries()) {
      const job = jobs.find((j) => j.id === jobId);
      const tasker = taskersSnapshot.docs.find((t) => t.id === taskerId);

      if (job && tasker) {
        const matchRef = db.collection("matching").doc();
        const distance = haversineDistance(job.location, tasker.data().location);
        batch.set(matchRef, {
          job_id: jobId,
          tasker_id: taskerId,
          distance: distance,
          // job_lat: job.location.latitude,
          // job_lon: job.location.longitude,
          // tasker_lat: tasker.data().location.latitude,
          // tasker_lon: tasker.data().location.longitude
        });
        //   jsonData.push({
        //     job_id: jobId,
        //     tasker_id: taskerId,
        //     job_lat: job.location.latitude,
        //     job_lon: job.location.longitude,
        //     tasker_lat: tasker.data().location.latitude,
        //     tasker_lon: tasker.data().location.longitude
        // });
      }
          
      console.log(`Assigned tasker ${taskerId} to job ${jobId}`);
    }
      
    await batch.commit();

  } catch (error) {
    console.error("Error generating data:", error);
  }

  // const fileUpload = bucket.file("kepler/tasker_job_connections_7.json");

  // await fileUpload.save(JSON.stringify(jsonData, null, 4), {
  //     contentType: "application/json",
  //     public: true,
  // });

  // Get Public URL
  // const publicUrl = `https://storage.googleapis.com/${bucket.name}/kepler/tasker_job_connections_7.json`;
  // console.log(`JSON file uploaded: ${publicUrl}`);

  console.log("Optimized task matching completed.");
  const endTime = performance.now();
  console.log(`Algorithm execution time: ${(endTime - startTime).toFixed(2)} ms`);
}


// eslint-disable-next-line @typescript-eslint/no-unused-vars
export const cleanUpMatchingData = onSchedule("every 24 hours", async (_context) => {
  const matchingSnapshot = await db.collection("matching").get();
  const currentTime = new Date().getTime();

  const batch = db.batch();

  matchingSnapshot.forEach((doc) => {
    const matchTime = doc.createTime.toDate().getTime();
    if (currentTime - matchTime >= 86400000) {
      batch.delete(doc.ref);
    }
  });

  await batch.commit();
  console.log("Matching data cleaned up successfully.");
});

setGlobalOptions({
  region: "us-central1", // ✅ Set region globally
  timeoutSeconds: 540,   // ✅ Max timeout (9 minutes)
  memory: "2GiB",         // ✅ Increase memory allocation
  cpu: 2                 // ✅ More processing power
});

// eslint-disable-next-line @typescript-eslint/no-unused-vars
export const onJobCreated = onDocumentCreated("jobs/{jobId}", async (_event) => {
  matchTaskersToJobs().then(() => {
    console.log("Tasker-Job matching completed successfully.");
    process.exit(0);
  }).catch((error) => {
    console.error("Error running tasker-job matching:", error);
    process.exit(1);
  });
});