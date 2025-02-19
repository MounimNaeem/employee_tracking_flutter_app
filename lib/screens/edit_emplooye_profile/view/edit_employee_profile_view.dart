import 'package:employee_location_tracking_app/common/widgets/app_bar/app_bar_widget.dart';
import 'package:employee_location_tracking_app/common/widgets/app_text_field.dart';
import 'package:employee_location_tracking_app/common/widgets/labeled_text_field.dart';
import 'package:employee_location_tracking_app/screens/admin_dashboard/models/employee_list_model.dart';
import 'package:employee_location_tracking_app/screens/admin_dashboard/view/admin_dashboard_view.dart';
import 'package:employee_location_tracking_app/screens/edit_emplooye_profile/provider/edit_employee_profile_provider.dart';
import 'package:employee_location_tracking_app/utils/enums/enums.dart';
import 'package:employee_location_tracking_app/utils/theme/font_styles/light_font_style/light_font_style.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditEmployeeProfileView extends ConsumerStatefulWidget {
  final EmployeeListModel employee;
  const EditEmployeeProfileView({Key? key, required this.employee})
      : super(key: key);

  @override
  ConsumerState<EditEmployeeProfileView> createState() =>
      _EditEmployeeProfileViewState();
}

class _EditEmployeeProfileViewState
    extends ConsumerState<EditEmployeeProfileView> {
  final provider =
      ChangeNotifierProvider((ref) => EditEmployeeProfileProvider());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(provider).initialization(widget.employee);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final notifier = ref.watch(provider);
    return Scaffold(
        extendBodyBehindAppBar: false,
        appBar: CustomAppBar(
            color: Colors.white,
            userName: widget.employee.firstName ?? '',
            showBackIcon: true,
            actionWidget: <Widget>[
              //   IconButton(
              //     icon: Icon(Icons.edit_outlined),
              //     onPressed: () {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) => EditEmployeeProfileView(
              //             employee: widget.employee,
              //           ),
              //         ),
              //       );
              //     },
              //   ),
              // IconButton(
              //   icon: Icon(Icons.delete_outline_outlined),
              //   onPressed: () {
              //     notifier.deleteEmployee(
              //         context, widget.employee.userUid ?? '');
              //   },
              // )
            ]

            // scaffoldKey: _scaffoldKey,
            ),
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: notifier.isLoading
              ? Center(
                  child: CircularProgressIndicator(
                  color: theme.primaryColor,
                ))
              : Form(
                  key: notifier.formKey,
                  child: Column(
                    children: [
                      53.verticalSpace,
                      LabeledTextField(
                        controller: notifier.firstNameController,
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
                        controller: notifier.emailController,
                        readOnly: true,
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
                        controller: notifier.phoneController,
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
                      // 16.verticalSpace,
                      // DropdownButtonFormField<UserType>(
                      //   value: notifier.selectedUserType,
                      //   style: bodyMedium.copyWith(color: Colors.black),
                      //   decoration: AppInputDecoration.getInputDecoration(
                      //     hintText: 'User Type',
                      //     hintStyle: bodyMedium.copyWith(color: Colors.black),
                      //   ),

                      //   // InputDecoration(
                      //   //   labelText: 'User Type',
                      //   //   border: OutlineInputBorder(
                      //   //     borderRadius: BorderRadius.circular(12.r),
                      //   //   ),
                      //   // ),
                      //   items: UserType.values.map((userType) {
                      //     return DropdownMenuItem(
                      //       value: userType,
                      //       child: Text(userType.name),
                      //     );
                      //   }).toList(),
                      //   onChanged: (value) {
                      //     notifier.updateSelectedUserType(value);
                      //   },
                      //   validator: (value) {
                      //     if (value == null) {
                      //       return 'Please select a user type';
                      //     }
                      //     return null;
                      //   },
                      // ),

                      24.verticalSpace,
                      SizedBox(
                        width: double.infinity,
                        height: 56.h,
                        child: ElevatedButton(
                          onPressed: notifier.isLoading
                              ? null
                              : () {
                                  notifier.updateEmployeeData(
                                      onSuccess: () {
                                        ref
                                            .read(adminDashboardProvider)
                                            .fetchAllUsers();
                                      },
                                      context: context,
                                      userUid: widget.employee.userUid ?? '');
                                  //  signupNotifier.signup(context)
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
                                  child: CircularProgressIndicator(
                                    color: theme.colorScheme.onPrimary,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'Update Profile',
                                  style: bodyLarge.copyWith(
                                    color: theme.colorScheme.onPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
        ));
  }
}
