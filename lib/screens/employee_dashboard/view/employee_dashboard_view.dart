import 'package:action_slider/action_slider.dart';
import 'package:employee_location_tracking_app/common/widgets/app_bar/app_bar_widget.dart';
import 'package:employee_location_tracking_app/screens/drawer/view/drawer_view.dart';
import 'package:employee_location_tracking_app/screens/employee_dashboard/provider/employee_provider.dart';
import 'package:employee_location_tracking_app/screens/employee_dashboard/widgets/status_widget.dart';
import 'package:employee_location_tracking_app/services/firebase_notification/provider/send_notification_provider.dart';
import 'package:employee_location_tracking_app/services/permission_manager/permission_manager.dart';
import 'package:employee_location_tracking_app/services/shared_prefs_service.dart';
import 'package:employee_location_tracking_app/utils/app_utils/app_utils.dart';
import 'package:employee_location_tracking_app/utils/static_info/static_info.dart';
import 'package:employee_location_tracking_app/utils/theme/font_styles/light_font_style/light_font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EmployeeDashboard extends ConsumerStatefulWidget {
  // final String userId;
  const EmployeeDashboard({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<EmployeeDashboard> createState() => _EmployeeDashboardState();
}

class _EmployeeDashboardState extends ConsumerState<EmployeeDashboard> {
  final provider = ChangeNotifierProvider(
    (ref) => EmployeeNotifier(),
  );
  final notificationProvider = ChangeNotifierProvider(
    (ref) => SendNotificationProvider(),
  );
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(provider).getCurrentLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shiftNotifier = ref.watch(provider);

    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        userName: StaticInfo.userModel?.fullName ?? 'Employee',
        scaffoldKey: _scaffoldKey,
      ),
      drawer: const DrawerView(),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: shiftNotifier.isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: theme.primaryColor,
              ),
            )
          : Stack(
              children: [
                // Google Map
                GoogleMap(
                  initialCameraPosition: shiftNotifier.initialCameraPosition ??
                      CameraPosition(
                        target: LatLng(23.8103, 90.4125),
                        zoom: 14.0,
                      ),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  zoomControlsEnabled: false,
                  markers: shiftNotifier.markers,
                  onMapCreated: (GoogleMapController controller) {
                    shiftNotifier.mapController = controller;
                  },
                ),

                // Status Card
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: EdgeInsets.only(
                        top: 16.h, left: 16.h, right: 16.h, bottom: 54.h),
                    decoration: BoxDecoration(
                      color: theme.scaffoldBackgroundColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.r),
                        topRight: Radius.circular(20.r),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xffACA8A8).withOpacity(0.2),
                          blurRadius: 15,
                          offset: const Offset(0, -15),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.circle,
                              color: shiftNotifier.isOnline
                                  ? Colors.green
                                  : Colors.red,
                              size: 15.sp,
                            ),
                            5.horizontalSpace,
                            Text(
                              shiftNotifier.isOnline ? 'Online' : 'Offline',
                              style: headingMedium,
                            ),
                          ],
                        ),
                        // 8.verticalSpace,
                        // Text(
                        //   'Swap the button for online',
                        //   style: textRegular.copyWith(),
                        // ),
                        16.verticalSpace,
                        Center(
                          child: ActionSlider.standard(
                            height: 50,
                            loadingIcon: const CircularProgressIndicator(
                              color: Colors.white,
                            ),
                            icon: const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                            ),
                            action: (controller) async {
                              controller.loading(); //starts loading animation
                              // final hasPermission =
                              //     await shiftNotifier
                              //     .checkAndRequestPermissions(context);
                              // if (!hasPermission) {
                              //   await shiftNotifier
                              //       .checkAndRequestPermissions(context);
                              //   // throw Exception("Location permission not granted.");
                              // } else {
                              //  await shiftNotifier.toggleOnlineStatus(context);
                              // }

                              final permissionManager =
                                  ref.read(permissionManagerProvider);
                              await permissionManager
                                  .checkPermissionAndNavigate(context);
                                  if (permissionManager.hasBackgroundPermission) {
      // Proceed with going online
      await shiftNotifier.toggleOnlineStatus(context);
      print('Employee is online');
    } else {
      // Handle case where permission is not granted
      print('Cannot go online without background permission');
    }
                              
                              // await Future.delayed(const Duration(seconds: 2));
                              controller.success(); //starts success animation
                              controller.reset(); //reset slider
                            },
                            child: shiftNotifier.isOnline
                                ? Text('Swipe to go Offline')
                                : Text('Swipe to go Online'),
                            // ... //many more parameters
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
