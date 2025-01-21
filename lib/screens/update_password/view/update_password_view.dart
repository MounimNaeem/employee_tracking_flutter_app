import 'package:employee_location_tracking_app/common/widgets/app_bar/app_bar_widget.dart';
import 'package:employee_location_tracking_app/common/widgets/labeled_text_field.dart';
import 'package:employee_location_tracking_app/screens/update_password/provider/update_password_provider.dart';
import 'package:employee_location_tracking_app/utils/theme/font_styles/light_font_style/light_font_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UpdatePasswordView extends ConsumerWidget {
  final provider = AutoDisposeProvider((ref) => UpdatePasswordProvider());
  final formKey = GlobalKey<FormState>();
  UpdatePasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(provider);
    final theme = Theme.of(context);
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: CustomAppBar(
        userName: '',
        showBackIcon: true,
        // scaffoldKey: _scaffoldKey,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 100.w,
                    // height: 100.h,
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
                    'Update Password',
                    style: headingLarge.copyWith(
                      fontSize: 22.sp,
                    ),
                  ),
                ),
                41.verticalSpace,
                LabeledTextField(
                  controller: notifier.currentPasswordController,
                  label: 'Current Password',
                  hintText: 'Enter your current password',
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                16.verticalSpace,
                LabeledTextField(
                  controller: notifier.newPasswordController,
                  label: 'New Passowrd',
                  hintText: 'Enter your New password',
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your new password';
                    }
                    return null;
                  },
                ),
                16.verticalSpace,
                LabeledTextField(
                  controller: notifier.confirmPasswordController,
                  label: 'Confirm Passowrd',
                  hintText: 'Enter your Confirm password',
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your confirm password';
                    }
                    return null;
                  },
                ),
                56.verticalSpace,
                SizedBox(
                  width: double.infinity,
                  height: 56.h,
                  child: ElevatedButton(
                    onPressed: notifier.isLoading
                        ? null
                        : () {
                            if (formKey.currentState!.validate()) {
                              notifier.updatePassword(
                                context: context,
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: notifier.isLoading
                        ? SizedBox(
                            height: 20.h,
                            width: 20.w,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Update Password',
                            style: buttonText.copyWith(
                              color: theme.colorScheme.onPrimary,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
