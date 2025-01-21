import 'package:employee_location_tracking_app/screens/auth/login/provider/login_provider.dart';
import 'package:employee_location_tracking_app/screens/auth/signup/view/signup_view.dart';
import 'package:employee_location_tracking_app/screens/forgot_password/view/forgot_password_view.dart';
import 'package:employee_location_tracking_app/utils/theme/font_styles/light_font_style/light_font_style.dart';
import 'package:employee_location_tracking_app/utils/theme/light_base_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:employee_location_tracking_app/common/widgets/labeled_text_field.dart';
import 'package:flutter_svg/flutter_svg.dart';

final loginNotifierProvider = ChangeNotifierProvider((ref) => LoginNotifier());

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;
  bool rememberMe = false;

  @override
  Widget build(BuildContext context) {
    final loginNotifier = ref.watch(loginNotifierProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  120.verticalSpace,
                  Center(
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 100.w,
                      height: 100.h,
                    ),
                    // SvgPicture.asset(
                    //   'assets/images/logo.svg',
                    //   // width: 100.w,
                    //   // height: 100.h,
                    // ),
                  ),
                  10.verticalSpace,
                  Center(
                    child: Text(
                      'Login',
                      style: headingLarge.copyWith(
                        fontSize: 32.sp,
                      ),
                    ),
                  ),
                  31.verticalSpace,
                  LabeledTextField(
                    controller: emailController,
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
                    controller: passwordController,
                    label: 'Password',
                    hintText: 'Enter your password',
                    isPassword: true,
                    isPasswordVisible: isPasswordVisible,
                    onTogglePassword: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  17.verticalSpace,
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ForgotPasswordView(),
                            ),
                          );
                        },
                        child: Text(
                          'Forgot Password?',
                          style: bodyMedium.copyWith(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        )),
                  ),
                  56.verticalSpace,
                  SizedBox(
                    width: double.infinity,
                    height: 56.h,
                    child: ElevatedButton(
                      onPressed: loginNotifier.isLoading
                          ? null
                          : () {
                              if (formKey.currentState!.validate()) {
                                loginNotifier.login(
                                  context: context,
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: loginNotifier.isLoading
                          ? SizedBox(
                              height: 20.h,
                              width: 20.w,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Log In',
                              style: buttonText.copyWith(
                                color: theme.colorScheme.onPrimary,
                              ),
                            ),
                    ),
                  ),
                  24.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account?',
                        style: bodySmall.copyWith(
                          color: theme.hintColor,
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignupScreen(),
                          ),
                        ),
                        child: Text(
                          'Sign Up',
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
      ),
    );
  }
}
