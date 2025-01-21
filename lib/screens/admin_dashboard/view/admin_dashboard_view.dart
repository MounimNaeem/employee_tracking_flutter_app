import 'package:employee_location_tracking_app/common/widgets/app_bar/app_bar_widget.dart';
import 'package:employee_location_tracking_app/screens/admin_dashboard/widgets/list_row_widget.dart';
import 'package:employee_location_tracking_app/screens/bottom_navigation_bar_view/bottom_navigation_bar_view.dart';
import 'package:employee_location_tracking_app/screens/drawer/view/drawer_view.dart';
import 'package:employee_location_tracking_app/screens/employee_history/view/employee_history_view.dart';
import 'package:employee_location_tracking_app/utils/theme/font_styles/light_font_style/light_font_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../provider/admin_dashboard_provider.dart';

final adminDashboardProvider =
    ChangeNotifierProvider((ref) => AdminDashboardNotifier());

class AdminDashboardView extends ConsumerStatefulWidget {
  const AdminDashboardView({Key? key}) : super(key: key);

  @override
  ConsumerState<AdminDashboardView> createState() => _AdminDashboardViewState();
}

class _AdminDashboardViewState extends ConsumerState<AdminDashboardView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(adminDashboardProvider).fetchAllUsers());
  }

  Widget _buildStatusIndicator(bool isActive) {
    // final isActive = status;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isActive
            ? Colors.green.withOpacity(0.1)
            : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        isActive ? 'Online' : 'Offline',
        style: TextStyle(
          color: isActive ? Colors.green : Colors.red,
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final adminProvider = ref.watch(adminDashboardProvider);

    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        userName: 'Employees List',
        scaffoldKey: _scaffoldKey,
      ),
      drawer: const DrawerView(),
      // bottomNavigationBar: BottomNavigationBarView(),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          110.verticalSpace,
          Expanded(
            child: adminProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : adminProvider.error != null
                    ? Center(child: Text(adminProvider.error!))
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        itemCount: adminProvider.employeeList.length,
                        itemBuilder: (context, index) {
                          final user = adminProvider.employeeList[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EmployeeHistoryView(
                                    userId: user.userId ?? '-1',
                                    employeeName: user.firstName ?? 'History',
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 16.h),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.w, vertical: 14.h),
                                child: Row(
                                  children: [
                                    // Employee Image
                                    CircleAvatar(
                                      radius: 20.r,
                                      backgroundImage: user.profileImage != null
                                          ? NetworkImage(user.profileImage)
                                          : const AssetImage(
                                              'assets/images/person_img.png',
                                              // fit: BoxFit.cover,
                                            ),
                                      // child: user['imageUrl'] == null
                                      //     ? Text(
                                      //         (user['name'] as String?)
                                      //                 ?.substring(0, 1)
                                      //                 .toUpperCase() ??
                                      //             'U',
                                      //         style: TextStyle(fontSize: 20.sp),
                                      //       )
                                      //     : null,
                                    ),
                                    16.horizontalSpace,
                                    // Employee Details
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Name
                                          ListRowWidget(
                                              titie: 'Name',
                                              body: user.firstName ?? ''),
                                          3.verticalSpace,
                                          ListRowWidget(
                                              titie: 'Email',
                                              body: user.email ?? ''),
                                          3.verticalSpace,
                                          ListRowWidget(
                                              titie: 'Contact',
                                              body: user.phone ?? ''),
                                          3.verticalSpace,
                                          Row(
                                            children: [
                                              Text(
                                                'Status: ',
                                                style: bodyMedium.copyWith(
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              _buildStatusIndicator(
                                                  user.isActive ?? false),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Track/Delete Button
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                            'assets/images/location_icon.svg'),
                                        4.verticalSpace,
                                        Text(
                                          'Track',
                                          style: bodyMedium.copyWith(
                                              color: theme.primaryColor),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
