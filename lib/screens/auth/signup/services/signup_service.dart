import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_location_tracking_app/screens/auth/signup/models/user_model.dart';
import 'package:employee_location_tracking_app/services/shared_prefs_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:crypto/crypto.dart';

class SignupResult {
  final bool success;
  final String? error;
  final UserModel? userData;

  SignupResult({
    required this.success,
    this.error,
    this.userData,
  });
}

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final SharedPrefsService _prefs = SharedPrefsService();

  Future<SignupResult> signUp({
    required String email,
    required String password,
    required UserModel userData,
  }) async {
    try {
      // Check if email already exists
      final existingUser = await _auth.fetchSignInMethodsForEmail(email);
      if (existingUser.isNotEmpty) {
        return SignupResult(
          success: false,
          error: 'Email already in use. Please use a different email.',
        );
      }

      // Create user in Firebase Auth
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        return SignupResult(
          success: false,
          error: 'Failed to create account. Please try again.',
        );
      }

      // Update user data with Firebase UID
      final updatedUserData = userData.copyWith(
        userUid: userCredential.user!.uid,
        userId: 'USR${DateTime.now().millisecondsSinceEpoch}',
      );

      // Save user data to Firestore
      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(updatedUserData.toJson());

      // Store user data locally
      await _prefs.setUserData(updatedUserData);

      return SignupResult(
        success: true,
        userData: updatedUserData,
      );
    } on FirebaseAuthException catch (e) {
      return SignupResult(
        success: false,
        error: _getFirebaseAuthErrorMessage(e.code),
      );
    } catch (e) {
      return SignupResult(
        success: false,
        error: 'An unexpected error occurred. Please try again.',
      );
    }
  }

  String _getFirebaseAuthErrorMessage(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'Email is already in use. Please use a different email.';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled. Please contact support.';
      case 'weak-password':
        return 'The password is too weak. Please use a stronger password.';
      default:
        return 'An error occurred during signup. Please try again.';
    }
  }
}

String deriveShortUserId(String uid) {
  final bytes = utf8.encode(uid);
  final digest = sha256.convert(bytes);
  final hashInt = digest.bytes.fold(0, (prev, byte) => (prev + byte) % 1000000);
  final hashString = hashInt.toString().padLeft(4, '0');
  return hashString.length > 6 ? hashString.substring(0, 6) : hashString;
}
