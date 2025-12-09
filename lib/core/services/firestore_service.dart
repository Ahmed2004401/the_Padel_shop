import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_profile.dart';

/// Service to handle Firestore user profile operations.
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Collection name for user profiles.
  static const String _usersCollection = 'users';

  /// Create or update a user profile in Firestore.
  Future<void> setUserProfile(UserProfile profile) async {
    try {
      await _firestore
          .collection(_usersCollection)
          .doc(profile.uid)
          .set(profile.toMap(), SetOptions(merge: true));
    } catch (e) {
      throw 'Failed to save user profile: $e';
    }
  }

  /// Get a user profile from Firestore.
  Future<UserProfile?> getUserProfile(String uid) async {
    try {
      final doc = await _firestore
          .collection(_usersCollection)
          .doc(uid)
          .get();

      if (!doc.exists) return null;

      return UserProfile.fromMap(doc.data()!);
    } catch (e) {
      throw 'Failed to fetch user profile: $e';
    }
  }

  /// Update specific fields of a user profile.
  Future<void> updateUserProfile(
    String uid,
    Map<String, dynamic> data,
  ) async {
    try {
      await _firestore
          .collection(_usersCollection)
          .doc(uid)
          .update({
        ...data,
        'updatedAt': DateTime.now(),
      });
    } catch (e) {
      throw 'Failed to update user profile: $e';
    }
  }

  /// Delete a user profile from Firestore.
  Future<void> deleteUserProfile(String uid) async {
    try {
      await _firestore.collection(_usersCollection).doc(uid).delete();
    } catch (e) {
      throw 'Failed to delete user profile: $e';
    }
  }

  /// Create a new user profile after authentication.
  Future<void> createUserProfile({
    required User user,
    String? displayName,
  }) async {
    final profile = UserProfile(
      uid: user.uid,
      email: user.email ?? '',
      displayName: displayName ?? user.displayName,
      phoneNumber: user.phoneNumber,
      photoURL: user.photoURL,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await setUserProfile(profile);
  }
}
