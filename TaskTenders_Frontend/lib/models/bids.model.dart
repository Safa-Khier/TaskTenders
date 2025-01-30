import 'package:cloud_firestore/cloud_firestore.dart';

/// Bid model
/// * [id]: The bid's unique identifier
/// * [jobId]: The bid's job ID
/// * [taskerId]: The bid's tasker ID
/// * [userName]: The tasker name
class Bid {
  String? id;
  String jobId;
  String taskerId;
  String userName;
  double bidAmount;
  String coverLetter;
  double rating;
  bool isAccepted;
  int completedProjects;
  DateTime bidDate;

  Bid({
    required this.id,
    required this.jobId,
    required this.taskerId,
    required this.userName,
    required this.bidAmount,
    required this.coverLetter,
    required this.rating,
    required this.isAccepted,
    required this.completedProjects,
    required this.bidDate,
  });

  toJson() {
    return {
      'id': id,
      'jobId': jobId,
      'taskerId': taskerId,
      'userName': userName,
      'bidAmount': bidAmount,
      'coverLetter': coverLetter,
      'rating': rating,
      'isAccepted': isAccepted,
      'completedProjects': completedProjects,
      'bidDate': bidDate,
    };
  }

  static Bid? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }

    try {
      return Bid(
        id: json['id'],
        jobId: json['jobId'],
        taskerId: json['taskerId'],
        userName: json['userName'],
        bidAmount: json['bidAmount'],
        coverLetter: json['coverLetter'],
        rating: json['rating'],
        isAccepted: json['isAccepted'] ?? false,
        completedProjects: json['completedProjects'],
        bidDate: (json['bidDate'] as Timestamp).toDate(),
      );
    } catch (e) {
      print('Error parsing bid: $e');
      return null;
    }
  }
}
