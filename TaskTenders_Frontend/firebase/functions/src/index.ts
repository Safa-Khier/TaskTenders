import * as admin from "firebase-admin";
import { GeoPoint } from "@google-cloud/firestore";
import { PriorityQueue } from "@datastructures-js/priority-queue"; // Efficient Min-Heap
import { Storage } from "@google-cloud/storage";

import * as fs from "fs";


const serviceAccount = JSON.parse(fs.readFileSync(__dirname + "/tasktenders-1-firebase-adminsdk-k43td-5cb02e9f4d.json", "utf-8"));
admin.initializeApp({ credential: admin.credential.cert(serviceAccount), storageBucket: "gs://tasktenders-1.firebasestorage.app",   });

const storage = new Storage({
  keyFilename: __dirname + "/tasktenders-1-firebase-adminsdk-k43td-5cb02e9f4d.json",
});
const bucket = storage.bucket("gs://tasktenders-1.firebasestorage.app");

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

    const taskers: User[] = taskersSnapshot.docs.map((doc) => ({
      uid: doc.id,
      ...doc.data(),
    } as User));

    const jobs: Job[] = jobsSnapshot.docs.map((doc) => ({
      id: doc.id,
      ...doc.data(),
    } as Job));

    // ✅ Step 1: Use a priority queue (Min-Heap) for efficient nearest neighbor search
    const taskerQueue = new PriorityQueue<{ tasker: User; distance: number }>(
      (a, b) => a.distance - b.distance
    );

    const assignments = new Map<string, string>(); // jobId -> taskerId

    // ✅ Step 2: Greedy assignment using Min-Heap
    for (const job of jobs) {
      taskerQueue.clear();

      for (const tasker of taskers) {
        const distance = haversineDistance(job.location, tasker.location);
        taskerQueue.enqueue({ tasker, distance });
      }

      if (!taskerQueue.isEmpty()) {
        const closestTaskerItem = taskerQueue.dequeue();
        if (!closestTaskerItem) continue; // Skip if no tasker is found
        const closestTasker = closestTaskerItem.tasker;
        assignments.set(job.id, closestTasker.uid);

        // Remove assigned tasker from available pool
        taskers.splice(taskers.findIndex((t) => t.uid === closestTasker.uid), 1);
      }
    }

    console.log("Initial Greedy Assignments:", assignments);

    // ✅ Step 3: Local Swap Optimization to refine assignments
    for (const [jobId1, taskerId1] of assignments.entries()) {
      for (const [jobId2, taskerId2] of assignments.entries()) {
        if (jobId1 === jobId2) continue;

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
          // Swap taskers if it reduces total travel distance
          assignments.set(jobId1, taskerId2);
          assignments.set(jobId2, taskerId1);
          console.log(`Swapped taskers for jobs ${jobId1} & ${jobId2} for efficiency.`);
        }
      }
    }

    console.log("Final Optimized Assignments:", assignments);

    const jsonData = [];

    for (const [jobId, taskerId] of assignments.entries()) {
        const job = jobs.find((j) => j.id === jobId);
        const tasker = taskersSnapshot.docs.find((t) => t.id === taskerId);

        if (job && tasker) {
            jsonData.push({
                job_id: jobId,
                tasker_id: taskerId,
                job_lat: job.location.latitude,
                job_lon: job.location.longitude,
                tasker_lat: tasker.data().location.latitude,
                tasker_lon: tasker.data().location.longitude
            });
        }

        console.log(`Assigned tasker ${taskerId} to job ${jobId}`);
    }

    const fileUpload = bucket.file("kepler/tasker_job_connections.json");

await fileUpload.save(JSON.stringify(jsonData, null, 4), {
    contentType: "application/json",
    public: true,
});

// Get Public URL
const publicUrl = `https://storage.googleapis.com/${bucket.name}/kepler/tasker_job_connections.json`;
console.log(`JSON file uploaded: ${publicUrl}`);

    console.log("Optimized task matching completed.");
    const endTime = performance.now();
    console.log(`Algorithm execution time: ${(endTime - startTime).toFixed(2)} ms`);
    };

    matchTaskersToJobs().then(() => {
        console.log("Tasker-Job matching completed successfully.");
        process.exit(0);
      }).catch((error) => {
        console.error("Error running tasker-job matching:", error);
        process.exit(1);
      });

    // Number of users and jobs to generate
const NUM_USERS = 10000;
const NUM_JOBS = 5000;

// Function to generate a random geolocation
function randomLocation() {
    return new admin.firestore.GeoPoint(
        parseFloat((Math.random() * 180 - 90).toFixed(6)),  // Latitude (-90 to 90)
        parseFloat((Math.random() * 360 - 180).toFixed(6))  // Longitude (-180 to 180)
    );
}

/**
 * Generates random users and jobs, then saves them to Firestore.
 */
export async function generateAndSaveData(){
    try {
        const batch = db.batch();

        // ✅ Generate Users
        for (let i = 0; i < NUM_USERS; i++) {
            const userRef = db.collection("users").doc(`user_${i}`);
            batch.set(userRef, {
                uid: `user_${i}`,
                role: "tasker",
                location: randomLocation()
            });
        }

        // ✅ Generate Jobs
        for (let i = 0; i < NUM_JOBS; i++) {
            const jobRef = db.collection("jobs").doc(`job_${i}`);
            batch.set(jobRef, {
                id: `job_${i}`,
                userId: `user_${Math.floor(Math.random() * NUM_USERS)}`, // Random user
                location: randomLocation(),
                status: "open"
            });
        }

        // ✅ Commit batch writes to Firestore
        await batch.commit();

        console.log("Generated and saved users & jobs successfully.");
    } catch (error) {
        console.error("Error generating data:", error);
    }
};

// generateAndSaveData().then(() => {
//     console.log("Data generation completed successfully.");
//     process.exit(0);
// }).catch((error) => {
//     console.error("Error generating data:", error);
//     process.exit(1);
// });