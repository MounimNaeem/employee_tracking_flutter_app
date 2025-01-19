import 'package:employee_location_tracking_app/screens/admin_dashboard/view/admin_dashboard_view.dart';
import 'package:employee_location_tracking_app/screens/auth/login/services/login_services.dart';
import 'package:employee_location_tracking_app/screens/auth/signup/models/user_model.dart';
import 'package:employee_location_tracking_app/screens/bottom_navigation_bar_view/bottom_navigation_bar_view.dart';
import 'package:employee_location_tracking_app/screens/employee_dashboard/view/employee_dashboard_view.dart';
import 'package:employee_location_tracking_app/services/shared_prefs_service.dart';
import 'package:employee_location_tracking_app/utils/app_utils/app_utils.dart';
import 'package:employee_location_tracking_app/utils/enums/enums.dart';
import 'package:employee_location_tracking_app/utils/static_info/static_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loginNotifierProvider = ChangeNotifierProvider((ref) => LoginNotifier());

class LoginNotifier extends ChangeNotifier {
  final LoginService _authService = LoginService();
  final SharedPrefsService _prefs = SharedPrefsService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  UserModel? _userModel;
  UserModel? get userModel => _userModel;

  Future<void> login({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _authService.login(
        email: email,
        password: password,
      );

      if (result.success && result.userData != null) {
        _userModel = result.userData;

        SharedPrefsService().setUserData(_userModel!);
        StaticInfo.userModel = _userModel;

        // Show success message and navigate
        if (context.mounted) {
          AppUtils.showSnackBar(
            context,
            message: 'Login successful!',
          );

          // Navigate to dashboard after short delay
          await Future.delayed(const Duration(seconds: 1));
          if (context.mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                // builder: (context) => const EmployeeDashboard(),
                builder: (context) => userModel?.userType == UserType.admin
                    ? const BottomNavigationBarView()
                    : const EmployeeDashboard(),
              ),
            );
          }
        }
      } else {
        if (context.mounted) {
          AppUtils.showSnackBar(
            context,
            message: result.error ?? 'Login failed',
            isError: true,
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        AppUtils.showSnackBar(
          context,
          message: 'An unexpected error occurred',
          isError: true,
        );
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> checkAuthStatus() async {
    try {
      final userData = await _prefs.getUserData();
      final isLoggedIn = await _prefs.isLoggedIn();

      if (userData != null && isLoggedIn) {
        _userModel = userData;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
