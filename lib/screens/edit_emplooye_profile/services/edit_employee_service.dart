import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditEmployeeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateUserData(String userId, Map<String, dynamic> updatedData) async {
    try {
      await _firestore.collection('users').doc(userId).update(updatedData);
      print("User data updated successfully");
    } catch (e) {
      print("Error updating user data: $e");
    }
  }


Future<void> deleteUserAccount({required String userUid}) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String uid = user.uid;

      // Delete user data from Firestore
      await _firestore.collection('users').doc(uid).delete();
      await _firestore.collection('liveLocations').doc(userUid).delete();
      await _firestore.collection('histories').doc(userUid).delete();

      // Delete user from Firebase Authentication
      await user.delete();
    }
  } catch (e) {
    print("Error deleting user account: $e");
  }
}

}
