import 'package:employee_location_tracking_app/utils/app_utils/app_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UpdatePasswordProvider extends ChangeNotifier {
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;

  void updatePassword({required BuildContext context}) async {
    // Check if the passwords match
    isLoading = true;
    notifyListeners();
    if (newPasswordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("New passwords do not match!")),
      );
      isLoading = false;
      notifyListeners();
      return;
    }

    User? user = _auth.currentUser;
    if (user != null) {
      try {
        // Reauthenticate user
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPasswordController.text.trim(),
        );
        await user.reauthenticateWithCredential(credential);

        // Update password
        await user.updatePassword(newPasswordController.text.trim());

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Password updated successfully!")),
        );
        // isLoading = false;
        // notifyListeners();
        Navigator.pop(context); // Go back to the previous screen
      } catch (e) {
        print('Error updating password: $e');
        if (e.toString().toLowerCase().contains('invalid-credential')) {
          AppUtils.showSnackBar(
            context,
            message: 'Invalid current password. Please try again.',
            isError: true,
          );
          return;
        } else if (e.toString().toLowerCase().contains('weak-password')) {
          AppUtils.showSnackBar(
            context,
            message:
                'New password is too weak. Password should be at least 6 characters.',
            isError: true,
          );
          return;
        }
        AppUtils.showSnackBar(
          context,
          message: 'Failed to update password. Please try again.',
          isError: true,
        );
        // isLoading = false;
        // notifyListeners();
      }
    } else {
      // isLoading = false;
      // notifyListeners();
    }
  }
}
