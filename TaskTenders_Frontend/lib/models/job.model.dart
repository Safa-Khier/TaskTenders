import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';
import 'package:tasktender_frontend/models/job_updates.model.dart';

/// Job model
/// * [id]: The job's unique identifier
/// * [userId]: The job's user ID
/// * [title]: The job's title
/// * [description]: The job's description
/// * [jobType]: The job's type
/// * [categoryId]: The job's category ID
/// * [price]: The job's price
/// * [createdAt]: The date the job was created
class Job {
  String? id;
  String userId;
  String? offerId;
  String title;
  String description;
  String jobType;
  String categoryId;
  List<String>? bidders;
  List<JobUpdates> updates;
  DateTime? offerAcceptedAt;
  bool? isReviewSubmitted;
  DateTime? completedAt;
  LatLng location;
  double price;
  String status;
  DateTime? deadline;
  DateTime createdAt;
  List<String> tags;

  Job({
    this.id,
    required this.userId,
    this.offerId,
    required this.title,
    required this.description,
    required this.jobType,
    required this.categoryId,
    required this.price,
    required this.tags,
    this.updates = const [],
    this.offerAcceptedAt,
    this.completedAt,
    this.isReviewSubmitted,
    this.bidders,
    required this.status,
    required this.location,
    required this.deadline,
    required this.createdAt,
  });

  toJson() {
    return {
      'id': id,
      'userId': userId,
      'offerId': offerId,
      'title': title,
      'description': description,
      'jobType': jobType,
      'categoryId': categoryId,
      'price': price,
      'status': status,
      'updates': updates.map((update) => update.toJson()).toList(),
      'offerAcceptedAt': offerAcceptedAt,
      'completedAt': completedAt,
      'isReviewSubmitted': isReviewSubmitted ?? false,
      'bidders': bidders,
      'location': GeoPoint(location.latitude, location.longitude),
      'createdAt': createdAt,
      'deadline': deadline,
      'tags': tags,
    };
  }

  static Job? fromJson(Map<String, dynamic> json) {
    try {
      GeoPoint geoPoint = json["location"] ?? GeoPoint(32.977799, 35.331813);
      final job = Job(
        id: json['id'],
        userId: json['userId'],
        offerId: json['offerId'],
        title: json['title'],
        description: json['description'],
        jobType: json['jobType'],
        categoryId: json['categoryId'],
        bidders: json['bidders']?.cast<String>() ?? [],
        offerAcceptedAt: json['offerAcceptedAt'] != null
            ? (json['offerAcceptedAt'] as Timestamp).toDate()
            : null,
        completedAt: json['completedAt'] != null
            ? (json['completedAt'] as Timestamp).toDate()
            : null,
        price: json['price'],
        status: json['status'],
        updates: (json['updates'] as List<dynamic>?)
                ?.map((update) => JobUpdates.fromJson(update))
                .toList() ??
            [],
        createdAt: (json['createdAt'] as Timestamp).toDate(),
        isReviewSubmitted: json['isReviewSubmitted'] ?? false,
        deadline: json['deadline'] != null
            ? (json['deadline'] as Timestamp).toDate()
            : null,
        location: LatLng(geoPoint.latitude, geoPoint.longitude),
        tags: json['tags'].cast<String>(),
      );
      return job;
    } catch (e) {
      print('Error parsing job: $e');
      return null;
    }
  }
}

enum JobType {
  regular,
  tender,
  volunteering,
}

enum JobStatus {
  open,
  closed,
  inProgress,
  completed,
}
