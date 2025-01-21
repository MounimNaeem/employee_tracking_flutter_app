import 'package:employee_location_tracking_app/utils/app_utils/app_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordProvider extends ChangeNotifier {
  bool isLoading = false;
   final FirebaseAuth _auth = FirebaseAuth.instance;


  Future<void> resetPassword({required BuildContext context, required String email}) async{
    isLoading = true;
    notifyListeners();
    try {
      await _auth.sendPasswordResetEmail(email:email);
      AppUtils.showSnackBar(
        context,
        message: 'Password reset email sent. Check your inbox!',
      );
      isLoading = false;
      notifyListeners();
      Navigator.pop(context); // Go back to the previous screen
    } catch (e) {
       AppUtils.showSnackBar(
        context,
        message: 'Please try again later',
      );
      isLoading = false;
      notifyListeners();
     
    }
  }
}
