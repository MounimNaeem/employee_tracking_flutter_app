import 'package:employee_location_tracking_app/common/widgets/labeled_text_field.dart';
import 'package:employee_location_tracking_app/screens/auth/signup/provider/signup_provider.dart';
import 'package:employee_location_tracking_app/utils/theme/font_styles/light_font_style/light_font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final signupNotifier = ref.watch(signupProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: signupNotifier.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                53.verticalSpace,
                Center(
                  child: Text(
                    'Sign up',
                    style: headingLarge.copyWith(
                      fontSize: 32.sp,
                    ),
                  ),
                ),
                53.verticalSpace,
                LabeledTextField(
                  controller: signupNotifier.firstNameController,
                  label: 'Full Name',
                  hintText: 'Enter your full name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                16.verticalSpace,
                LabeledTextField(
                  controller: signupNotifier.emailController,
                  label: 'Email',
                  hintText: 'Enter your email',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                16.verticalSpace,
                LabeledTextField(
                  controller: signupNotifier.phoneController,
                  label: 'Phone Number',
                  hintText: 'Enter your phone number',
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(11),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    if (value.length != 11) {
                      return 'Phone number must be 11 digits';
                    }
                    return null;
                  },
                ),
                16.verticalSpace,
                LabeledTextField(
                  controller: signupNotifier.passwordController,
                  label: 'Set Password',
                  hintText: 'Enter your password',
                  isPassword: true,
                  isPasswordVisible: isPasswordVisible,
                  onTogglePassword: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                  validator: signupNotifier.validatePassword,
                ),
                24.verticalSpace,
                SizedBox(
                  width: double.infinity,
                  height: 56.h,
                  child: ElevatedButton(
                    onPressed: signupNotifier.isLoading
                        ? null
                        : () => signupNotifier.signup(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: signupNotifier.isLoading
                        ? SizedBox(
                            height: 20.h,
                            width: 20.w,
                            child: CircularProgressIndicator(
                              color: theme.colorScheme.onPrimary,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Register',
                            style: bodyLarge.copyWith(
                              color: theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                16.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: bodySmall.copyWith(
                        color: theme.hintColor,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Login',
                        style: bodySmall.copyWith(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
