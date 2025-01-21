import 'package:employee_location_tracking_app/screens/auth/login/view/login_view.dart';
import 'package:employee_location_tracking_app/screens/auth/signup/models/user_model.dart';
import 'package:employee_location_tracking_app/screens/auth/signup/services/signup_service.dart';
import 'package:employee_location_tracking_app/utils/app_utils/app_utils.dart';
import 'package:employee_location_tracking_app/utils/enums/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final signupProvider = ChangeNotifierProvider((ref) => SignupNotifier());

class SignupNotifier extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final FirebaseAuthService _authService = FirebaseAuthService();

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> signup(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final userData = UserModel(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        userType: UserType.employee,
        isActive: false,
      );

      final result = await _authService.signUp(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        userData: userData,
      );

      if (!context.mounted) return;

      if (result.success) {
        AppUtils.showSnackBar(
          context,
          message: 'Account created successfully!',
        );

        // Clear form
        _clearForm();

        // Navigate to login screen after short delay
        Future.delayed(const Duration(seconds: 1), () {
          if (!context.mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        });
      } else {
        AppUtils.showSnackBar(
          context,
          message: result.error ?? 'Signup failed',
          isError: true,
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      AppUtils.showSnackBar(
        context,
        message: 'An unexpected error occurred',
        isError: true,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _clearForm() {
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    phoneController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
