import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_location_tracking_app/screens/auth/signup/models/user_model.dart';
import 'package:employee_location_tracking_app/services/shared_prefs_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginResult {
  final bool success;
  final String? error;
  final UserModel? userData;

  LoginResult({
    required this.success,
    this.error,
    this.userData,
  });
}

class LoginService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final SharedPrefsService _prefs = SharedPrefsService();

  Future<LoginResult> login({
    required String email,
    required String password,
  }) async {
    try {
      // Sign in with Firebase
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        return LoginResult(
          success: false,
          error: 'Login failed. Please try again.',
        );
      }

      // Get user data from Firestore
      final userData = await _getUserData(userCredential.user!.uid);
      if (userData == null) {
        return LoginResult(
          success: false,
          error: 'User data not found.',
        );
      }

      // Store user data locally
      await _prefs.setUserData(userData);

      return LoginResult(
        success: true,
        userData: userData,
      );
    } on FirebaseAuthException catch (e) {
      return LoginResult(
        success: false,
        error: _getFirebaseAuthErrorMessage(e.code),
      );
    } catch (e) {
      return LoginResult(
        success: false,
        error: 'An unexpected error occurred. Please try again.',
      );
    }
  }

  Future<UserModel?> _getUserData(String uid) async {
    try {
      final docSnapshot = await _firestore.collection('users').doc(uid).get();
      if (docSnapshot.exists) {
        return UserModel.fromJson(docSnapshot.data()!);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    await _prefs.clearUserData();
  }

  String _getFirebaseAuthErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many login attempts. Please try again later.';
      default:
        return 'An error occurred during login. Please try again.';
    }
  }
}