import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';

/// User model
/// * [uid]: The user's unique identifier
/// * [firstName]: The user's firstName
/// * [lastName]: The user's lastName
/// * [email]: The user's email
/// * [id]: The user's ID
/// * [phone]: The user's phone number
/// * [dateOfBirth]: The user's date of birth
/// * [role]: The user's role
/// * [createdAt]: The date the user was created
/// * [updatedAt]: The date the user was last updated
class UserDetails {
  String? uid;
  String firstName;
  String lastName;
  String email;
  String id;
  String phone;
  DateTime dateOfBirth;
  UserRole role;
  Map<String, int> rating;
  int completedJobs;
  LatLng location;
  DateTime createdAt;
  DateTime updatedAt;

  UserDetails({
    this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.id,
    required this.phone,
    required this.role,
    required this.dateOfBirth,
    required this.rating,
    required this.completedJobs,
    required this.location,
    required this.createdAt,
    required this.updatedAt,
  });

  get fullName => '$firstName $lastName';

  double get overAllRating {
    int total = 0;
    int count = 0;
    rating.forEach((key, value) {
      total += int.parse(key) * value;
      count += value;
    });
    if (count == 0) {
      return 0;
    }
    return total / count;
  }

  get totalRates {
    int total = 0;
    rating.forEach((key, value) {
      total += value;
    });
    return total;
  }

  static toMap(UserDetails userDetails) {
    return {
      'uid': userDetails.uid,
      'firstName': userDetails.firstName,
      'lastName': userDetails.lastName,
      'email': userDetails.email,
      'id': userDetails.id,
      'phone': userDetails.phone,
      'dateOfBirth': userDetails.dateOfBirth,
      'role': userDetails.role.name,
      'rating': userDetails.rating,
      'completedJobs': userDetails.completedJobs,
      'location': GeoPoint(
          userDetails.location.latitude, userDetails.location.longitude),
      'createdAt': userDetails.createdAt,
      'updatedAt': userDetails.updatedAt,
    };
  }
}

/// Enum for user roles
/// * [client]: The user is a client
/// * [tasker]: The user is a tasker
/// * [admin]: The user is an admin
enum UserRole {
  client,
  tasker,
  admin,
}

/// Extension for [UserRole] to convert to a readable string
/// * [toReadableString]: Converts the [UserRole] to a readable string
extension MyEnumExtension on UserRole {
  String toReadableString() {
    switch (this) {
      case UserRole.admin:
        return "admin";
      case UserRole.client:
        return "client";
      case UserRole.tasker:
        return "tasker";
    }
  }
}
