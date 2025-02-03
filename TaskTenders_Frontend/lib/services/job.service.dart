import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tasktender_frontend/models/bids.model.dart';
import 'package:tasktender_frontend/models/job.model.dart';
import 'package:tasktender_frontend/models/job_updates.model.dart';
import 'package:tasktender_frontend/models/message.model.dart';
import 'package:tasktender_frontend/services/locator.service.dart';
import 'package:tasktender_frontend/services/user.service.dart';

class JobService {
  final UserService _userService = locator<UserService>();

  static const String _collectionName = 'jobs';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  JobService();

  Future<void> createJob(Job job) async {
    try {
      final docRef = _firestore.collection(_collectionName).doc();
      job.id = docRef.id;
      await docRef.set(job.toJson());
    } catch (e) {
      print('Error creating job: $e');
    }
  }

  Future<List<Job>> getJobs() async {
    try {
      // Get all jobs for the current user
      final snapshot = await _firestore
          .collection(_collectionName)
          .where('userId', isEqualTo: _userService.getUserUid())
          .get();
      return snapshot.docs
          .map<Job?>((doc) => Job.fromJson(doc.data()))
          .where((job) => job != null) // Filter out null values
          .map<Job>((job) => job!) // Safely cast to non-nullable
          .toList();
    } catch (e) {
      print('Error getting jobs: $e');
      return [];
    }
  }

  Future<void> editJob(Job job) async {
    try {
      await _firestore
          .collection(_collectionName)
          .doc(job.id)
          .update(job.toJson());
    } catch (e) {
      print('Error updating job: $e');
    }
  }

  Future<void> deleteJob(String jobId) async {
    try {
      await _firestore.collection(_collectionName).doc(jobId).delete();
    } catch (e) {
      print('Error deleting job: $e');
    }
  }

  Future<void> addNewUpdate(String jobId, JobUpdates update) async {
    try {
      await _firestore.collection(_collectionName).doc(jobId).update({
        'updates': FieldValue.arrayUnion([update.toJson()])
      });
    } catch (e) {
      print('Error adding update: $e');
    }
  }

  Future<List<Job>> getJobsForTaksers() async {
    try {
      // Get all jobs for the current user
      final snapshot = await _firestore
          .collection(_collectionName)
          .where('status', isEqualTo: 'open')
          .get();
      return snapshot.docs
          .map<Job?>((doc) => Job.fromJson(doc.data()))
          .where((job) => job != null) // Filter out null values
          .map<Job>((job) => job!) // Safely cast to non-nullable
          .toList();
    } catch (e) {
      print('Error getting jobs: $e');
      return [];
    }
  }

  Future<Job?> getJobById(jobId) async {
    try {
      final doc = await _firestore.collection(_collectionName).doc(jobId).get();
      return Job.fromJson(doc.data() as Map<String, dynamic>);
    } catch (e) {
      print('Error getting job: $e');
      return null;
    }
  }

  Future<List<Job>> loadJobs({int limit = 10, Job? lastDocument}) async {
    try {
      Query query = _firestore
          .collection('jobs')
          .orderBy('createdAt', descending: true)
          .limit(limit);

      if (lastDocument != null) {
        query = query.startAfter([lastDocument.createdAt]);
      }

      final QuerySnapshot snapshot = await query.get();

      return snapshot.docs
          .map<Job?>((doc) => Job.fromJson(doc.data() as Map<String, dynamic>))
          .where((job) => job != null) // Filter out null values
          .map<Job>((job) => job!) // Safely cast to non-nullable
          .toList();
    } catch (e) {
      print("Error loading jobs: $e");
      return [];
    }
  }

  Future<void> addOfferOnJob(Bid bid) async {
    try {
      await _firestore.runTransaction((transaction) async {
        // Get the job document
        final jobDocRef = _firestore.collection(_collectionName).doc(bid.jobId);

        // add userId to the bidders list
        transaction.update(jobDocRef, {
          'bidders': FieldValue.arrayUnion([bid.taskerId])
        });

        // Add the bid to the 'bids' subcollection
        final bidDocRef = jobDocRef.collection('bids').doc();
        bid.id = bidDocRef.id;
        transaction.set(bidDocRef, bid.toJson());
      });
    } catch (e) {
      print('Error creating job: $e');
    }
  }

  Future<List<Job>> getJobsForTasker() async {
    try {
      // Get all jobs for the current user
      final snapshot = await _firestore
          .collection(_collectionName)
          .where('bidders', arrayContains: _userService.getUserUid())
          .get();
      return snapshot.docs
          .map<Job?>((doc) => Job.fromJson(doc.data()))
          .where((job) => job != null) // Filter out null values
          .map<Job>((job) => job!) // Safely cast to non-nullable
          .toList();
    } catch (e) {
      print('Error getting jobs: $e');
      return [];
    }
  }

  Future<Bid?> getBidById(String jobId, String offerId) async {
    try {
      final bidDoc = await _firestore
          .collection(_collectionName)
          .doc(jobId)
          .collection('bids')
          .doc(offerId)
          .get();

      if (!bidDoc.exists) {
        return null;
      }

      return Bid.fromJson(bidDoc.data());
    } catch (e) {
      print('Error getting bids: $e');
      return null;
    }
  }

  Future<List<Bid>> getUserBidsByJobId(String jobId) async {
    try {
      final snapshot = await _firestore
          .collection(_collectionName)
          .doc(jobId)
          .collection('bids')
          // .where('taskerId', isEqualTo: _userService.getUserUid())
          // .orderBy('bidDate', descending: true)
          .get();
      return snapshot.docs
          .map<Bid?>((doc) => Bid.fromJson(doc.data()))
          .where((bid) => bid != null) // Filter out null values
          .map<Bid>((bid) => bid!) // Safely cast to non-nullable
          .toList();
    } catch (e) {
      print('Error getting bids: $e');
      return [];
    }
  }

  Future<List<Bid>> getJobBids(String jobId) async {
    try {
      final snapshot = await _firestore
          .collection(_collectionName)
          .doc(jobId)
          .collection('bids')
          .get();
      return snapshot.docs
          .map<Bid?>((doc) => Bid.fromJson(doc.data()))
          .where((bid) => bid != null) // Filter out null values
          .map<Bid>((bid) => bid!) // Safely cast to non-nullable
          .toList();
    } catch (e) {
      print('Error getting bids: $e');
      return [];
    }
  }

  Future<void> acceptOffer(Bid bid) async {
    try {
      await _firestore.runTransaction((transaction) async {
        // Get the job document
        final jobDocRef = _firestore.collection(_collectionName).doc(bid.jobId);

        // Update the job status and offerId
        transaction.update(jobDocRef, {
          'status': 'in-progress',
          'offerId': bid.id,
          'offerAcceptedAt': FieldValue.serverTimestamp(),
        });

        // Get the bid document in the 'bids' subcollection
        final bidDocRef = jobDocRef.collection('bids').doc(bid.id);

        // Update the isAccepted field
        transaction.update(bidDocRef, {'isAccepted': true});
      });

      print('Bid accepted successfully!');
    } catch (e) {
      print('Error accepting bid: $e');
    }
  }

  Future<void> sendMessageInJobChat(String jobId, Message message,
      {String chatName = 'chat'}) async {
    try {
      final docRef = _firestore
          .collection(_collectionName)
          .doc(jobId)
          .collection(chatName)
          .doc();
      message.id = docRef.id;
      docRef.set(message.toJson());
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  // Stream of chat messages for a specific job
  Stream<List<Message>> getJobChatMessages(String jobId,
      {String chatName = 'chat'}) {
    return _firestore
        .collection(_collectionName)
        .doc(jobId)
        .collection(chatName)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map<Message?>((doc) => Message.fromJson(doc.data()))
            .where((message) => message != null) // Filter out null values
            .map<Message>((message) => message!) // Safely cast to non-nullable
            .toList());
  }

  Future<void> completeJob(String jobId) async {
    try {
      await _firestore.runTransaction((transaction) async {
        // Get the job document
        final jobDocRef = _firestore.collection(_collectionName).doc(jobId);

        // Update the job status and completedAt field
        transaction.update(jobDocRef, {
          'status': 'completed',
          'completedAt': FieldValue.serverTimestamp(),
        });

        final userDocRef =
            _firestore.collection('users').doc(_userService.getUserUid());

        // Update the user's job count
        transaction.update(userDocRef, {
          'completedJobs': FieldValue.increment(1),
        });
      });
    } catch (e) {
      print('Error completing job: $e');
    }
  }

  Future<List<Job>> getBestMatchingJobs() async {
    try {
      final userId = _userService.getUserUid();
      final snapshot = await _firestore
          .collection('matching')
          .where('tasker_id', isEqualTo: userId)
          .get();

      final jobIds = snapshot.docs
          .map<String>((doc) => doc.data()['job_id'] as String)
          .toList();

      final jobs = await Future.wait(jobIds.map((jobId) => getJobById(jobId)));

      return jobs.where((job) => job != null).map<Job>((job) => job!).toList();
    } catch (e) {
      print('Error getting best matching jobs: $e');
      return [];
    }
  }
}
