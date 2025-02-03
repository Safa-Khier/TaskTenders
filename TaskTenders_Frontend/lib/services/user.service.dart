import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:tasktender_frontend/models/reviews.model.dart';
import 'package:tasktender_frontend/models/user.model.dart';
import 'package:tasktender_frontend/routes/app_router.dart';
import 'package:tasktender_frontend/routes/app_router.gr.dart';
import 'package:tasktender_frontend/services/loading.service.dart';
import 'package:tasktender_frontend/services/preferences.service.dart';

class UserService {
  static const String _collectionName = 'users';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserDetails? userDetails;

  final PreferencesService _preferencesService = PreferencesService();

  UserService();

  bool isAuthenticated() {
    return _auth.currentUser != null;
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Automatically navigate to home if the user is logged in
  void handleAuthState(AppRouter appRouter) {
    _auth.authStateChanges().listen((User? user) async {
      if (user != null) {
        print('User is signed in, ${user.email} - ${user.uid}');
        getUserDetails(user.uid).then((userDetails) {
          this.userDetails = userDetails;
          switch (userDetails?.role) {
            case UserRole.client:
              appRouter.replaceAll([ClientHomeRoute()]);
              break;
            case UserRole.tasker:
              appRouter.replaceAll([TaskerHomeRoute()]);
              break;
            default:
              appRouter.replaceAll([RegisterComplitionRoute()]);
              break;
          }
        });
      } else {
        print('User is currently signed out!');
        // appRouter.replace(WelcomeRoute());
        bool isFirstLaunch = await _preferencesService.isFirstLaunch();
        if (isFirstLaunch) {
          appRouter.replaceNamed('/intro');
        } else {
          appRouter.replaceNamed('/welcome');
        }
        // else {
        //   appRouter.replaceNamed('/');
        // }
        userDetails = null;
      }
    });
  }

  String getUserUid() {
    return _auth.currentUser?.uid ?? '';
  }

  String getUserFirstName() {
    return userDetails?.firstName ?? '';
  }

  String getUserImageUrl() {
    return _auth.currentUser?.photoURL ?? '';
  }

  String getUserLastName() {
    return userDetails?.lastName ?? '';
  }

  String getUserName() {
    return '${getUserFirstName()} ${getUserLastName()}';
  }

  String getUserRole() {
    return userDetails?.role.name ?? '';
  }

  String getUserEmail() {
    return _auth.currentUser?.email ?? '';
  }

  String getUserId() {
    return userDetails?.id ?? '';
  }

  String getUserPhone() {
    return userDetails?.phone ?? '';
  }

  Future<UserRole?> getUserType() async {
    if (userDetails != null) {
      return userDetails!.role;
    }
    return (await getUserDetails(_auth.currentUser!.uid))?.role;
  }

  // Register a new user
  Future<void> registerUser(
      BuildContext context, String email, String password) async {
    LoadingService.showLoadingIndicator(context);
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      log('Error registering user: $e');
    }
  }

  Future<void> completeRegistration(UserDetails userDetails) async {
    final currentUser = getCurrentUser();
    try {
      if (currentUser == null) {
        return;
      }
      print(UserDetails.toMap(userDetails));
      await _firestore
          .collection(_collectionName)
          .doc(currentUser.uid)
          .set(UserDetails.toMap(userDetails));
      this.userDetails = userDetails;
    } catch (e) {
      log('Error completing user registration: $e');
    }
  }

  // Login user
  Future<void> loginUser(
      BuildContext context, String email, String password) async {
    LoadingService.showLoadingIndicator(context);
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      log('Error logging in user: $e');
    } finally {
      // LoadingService.hideLoadingIndicator();
    }
  }

  Future<UserDetails?> getUserDetails(String userId) async {
    DocumentSnapshot userDoc =
        await _firestore.collection(_collectionName).doc(userId).get();

    if (!userDoc.exists) {
      return null;
    }

    final userData = userDoc.data() as Map<String, dynamic>?;

    GeoPoint location = (userData != null && userData.containsKey('location'))
        ? userData['location']
        : GeoPoint(0, 0);

    return UserDetails(
      uid: userId,
      firstName: userDoc['firstName'],
      lastName: userDoc['lastName'],
      email: userDoc['email'],
      id: userDoc['id'],
      phone: userDoc['phone'],
      dateOfBirth: userDoc['dateOfBirth'].toDate(),
      role: UserRole.values.firstWhere(
        (e) => e.name == userDoc['role'],
      ),
      rating: (userDoc['rating'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, (value as num).toInt()),
          ) ??
          {'1': 0, '2': 0, '3': 0, '4': 0, '5': 0},
      completedJobs: userDoc['completedJobs'] ?? 0,
      location: LatLng(
        location.latitude,
        location.longitude,
      ),
      createdAt: userDoc['createdAt']?.toDate() ?? DateTime.now(),
      updatedAt: userDoc['updatedAt']?.toDate() ?? DateTime.now(),
    );
  }

  // Logout user
  Future<void> logoutUser(BuildContext context) async {
    LoadingService.showLoadingIndicator(context);
    try {
      await _auth.signOut();
    } catch (e) {
      log('Error logging out user: $e');
    } finally {
      LoadingService.hideLoadingIndicator();
    }
  }

  // Update user profile
  Future<void> updateUserProfile(
      String userId, Map<String, dynamic> updates) async {
    try {
      await _firestore.collection('users').doc(userId).update(updates);
    } catch (e) {
      log('Error updating user profile: $e');
    }
  }

  Future<void> reviewSubmit(String taskerId, Reviews review) async {
    final taskerDoc = _firestore.collection('users').doc(taskerId);
    final reviewDoc = taskerDoc.collection('reviews').doc();
    final jobDoc = _firestore.collection('jobs').doc(review.jobId);

    try {
      _firestore.runTransaction((transaction) async {
        final DocumentSnapshot taskerSnap = await transaction.get(taskerDoc);

        if (!taskerSnap.exists) {
          throw Exception("Document does not exist!");
        }

        final String ratingKey = review.rating.toString();

        Map<String, dynamic> ratings = taskerSnap.get('rating') ?? {};
        int currentCount = (ratings[ratingKey] ?? 0) as int;

        ratings[ratingKey] = currentCount + 1;

        transaction.update(taskerDoc, {"rating": ratings});

        review.id = reviewDoc.id;

        transaction.set(reviewDoc, review.toJson());

        transaction.update(jobDoc, {"isReviewSubmitted": true});
      });
    } catch (e) {
      log('Error submitting review: $e');
    }
  }

  Future<String> getUserNameById(String userId) async {
    final user = await getUserDetails(userId);
    return '${user?.firstName} ${user?.lastName}';
  }
}
