import 'package:cloud_firestore/cloud_firestore.dart';

class JobUpdates {
  String title;
  String description;
  DateTime date;

  JobUpdates(
      {required this.title, required this.description, required this.date});

  toJson() {
    return {
      'title': title,
      'description': description,
      'date': date,
    };
  }

  factory JobUpdates.fromJson(Map<String, dynamic> json) {
    return JobUpdates(
      title: json['title'],
      description: json['description'],
      date: (json['date'] as Timestamp).toDate(),
    );
  }
}
