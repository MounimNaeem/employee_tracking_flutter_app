import 'package:employee_location_tracking_app/screens/admin_dashboard/widgets/list_row_widget.dart';
import 'package:employee_location_tracking_app/screens/employees_tracking/models/employee_tracking_model.dart';
import 'package:employee_location_tracking_app/utils/theme/font_styles/light_font_style/light_font_style.dart';
import 'package:employee_location_tracking_app/utils/theme/light_base_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppUtils {
  static void showSnackBar(
    BuildContext context, {
    required String message,
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: bodyMedium.copyWith(
            color: whiteColor,
          ),
        ),
        backgroundColor: isError ? redColor : primaryColor,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16.r),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
  }

  static Future<bool> showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String message,
    String? iconPath,
    String confirmText = 'Yes',
    String cancelText = 'No',
    required Function() onConfirm,
  }) async {
    final theme = Theme.of(context);
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Center(
              child: Wrap(
                children: [
                  Dialog(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32.w),
                      child: Column(
                        children: [
                          16.verticalSpace,
                          if (iconPath != null)
                            SvgPicture.asset(
                              iconPath,
                              // width: 50.w,
                              // height: 50.h,
                            ),
                          32.verticalSpace,
                          if (title.isNotEmpty)
                            Text(
                              title,
                              style: headingLarge.copyWith(
                                color: theme.primaryColor,
                              ),
                            ),
                          // 16.verticalSpace,
                          Text(
                            message,
                            style: bodyMedium.copyWith(
                              color: theme.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          13.verticalSpace,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: redColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 12.h, horizontal: 32.w),
                                ),
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: Text(
                                  cancelText,
                                  style: bodyMedium.copyWith(
                                    color: whiteColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              16.horizontalSpace,
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Color(0xff86E99F),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 12.h, horizontal: 32.w),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                  onConfirm();
                                },
                                child: Text(
                                  confirmText,
                                  style: bodyMedium.copyWith(
                                    color: whiteColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          16.verticalSpace,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ) ??
        false;
  }

  static Future<bool> showLocationDetailDialog({
    required BuildContext context,
    required EmployeeTrackingModel employee,
    String? iconPath,
  }) async {
    final theme = Theme.of(context);
    return await showDialog<bool>(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return Center(
              child: Wrap(
                children: [
                  Dialog(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32.w),
                      child: Column(
                        children: [
                          16.verticalSpace,
                          if (iconPath != null)
                            SvgPicture.asset(
                              iconPath,
                              color: theme.primaryColor,
                              width: 30.w,
                              // height: 50.h,
                            ),
                          18.verticalSpace,

                          Text(
                            employee.employeeName ?? '',
                            style: headingLarge.copyWith(
                              color: theme.primaryColor,
                            ),
                          ),
                          10.verticalSpace,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Location: ',
                                style: bodyMedium.copyWith(
                                    fontWeight: FontWeight.w600),
                              ),
                              Expanded(
                                child: Text(
                                  employee.address ?? '',
                                  style: bodyMedium,
                                ),
                              ),
                            ],
                          ),
                          // ListRowWidget(titie: 'Location', body: employee.address ?? ''),
                          5.verticalSpace,
                          ListRowWidget(
                              titie: 'Last Updated', body: employee.time ?? ''),
                          16.verticalSpace,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ) ??
        false;
  }
}
