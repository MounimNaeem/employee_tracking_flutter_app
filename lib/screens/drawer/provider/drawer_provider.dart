import 'package:employee_location_tracking_app/screens/auth/login/services/login_services.dart';
import 'package:employee_location_tracking_app/screens/auth/login/view/login_view.dart';
import 'package:employee_location_tracking_app/services/shared_prefs_service.dart';
import 'package:employee_location_tracking_app/utils/app_utils/app_utils.dart';
import 'package:flutter/material.dart';

class DrawerProvider extends ChangeNotifier {
  final LoginService _authService = LoginService();
  final SharedPrefsService _prefs = SharedPrefsService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> logout(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.logout();
      // _userModel = null;

      if (context.mounted) {
        AppUtils.showSnackBar(
          context,
          message: 'Logged out successfully',
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } catch (e) {
      print('Error logging out: $e');
      if (context.mounted) {
        AppUtils.showSnackBar(
          context,
          message: 'Failed to logout',
          isError: true,
        );
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
