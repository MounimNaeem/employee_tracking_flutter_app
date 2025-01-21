import 'package:employee_location_tracking_app/common/widgets/app_bar/app_bar_widget.dart';
import 'package:employee_location_tracking_app/screens/drawer/view/drawer_view.dart';
import 'package:employee_location_tracking_app/screens/employees_tracking/provider/employee_tracking_provider.dart';
import 'package:employee_location_tracking_app/utils/string_extentions/string_extentions.dart';
import 'package:employee_location_tracking_app/utils/theme/font_styles/light_font_style/light_font_style.dart';
import 'package:employee_location_tracking_app/utils/theme/light_base_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EmployeesTrackingView extends ConsumerStatefulWidget {
  const EmployeesTrackingView({Key? key}) : super(key: key);

  @override
  ConsumerState<EmployeesTrackingView> createState() =>
      _EmployeesTrackingViewState();
}

class _EmployeesTrackingViewState extends ConsumerState<EmployeesTrackingView> {
  final employeeTrackingProvider = ChangeNotifierProvider(
    (ref) => EmployeeTrackingProvider(),
  );

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(employeeTrackingProvider).listenToUserLocation(context: context);
    });
  }

  @override
  void dispose() {
    EmployeeTrackingProvider().stopListeningToUserLocation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final notifier = ref.watch(employeeTrackingProvider);

    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        userName: 'Employee Tracker',
        scaffoldKey: _scaffoldKey,
      ),
      drawer: const DrawerView(),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: notifier.isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: theme.primaryColor,
              ),
            )
          : Stack(
              children: [
                // Google Map
                GoogleMap(
                  initialCameraPosition: notifier.initialCameraPosition ??
                      CameraPosition(
                        target: LatLng(23.8103, 90.4125),
                        zoom: 14.0,
                      ),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  zoomControlsEnabled: false,
                  markers: notifier.markers,
                  onMapCreated: (GoogleMapController controller) {
                    notifier.mapController = controller;
                  },
                ),

                // Status Card
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    height: ScreenUtil().screenHeight * 0.4,
                    // padding: EdgeInsets.only(
                    //     top: 29.h, left: 24.h, right: 24.h, bottom: 54.h),
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
                        Padding(
                          padding: EdgeInsets.only(
                            top: 29.h,
                            left: 24.h,
                            right: 24.h,
                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                  'assets/images/location_icon.svg'),
                              10.horizontalSpace,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Track',
                                    style: bodyMedium.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: theme.primaryColor,
                                    ),
                                  ),
                                  Text(
                                    'Select an employee to locate',
                                    style: bodySmall.copyWith(
                                        // fontWeight: FontWeight.w600,
                                        // color: theme.primaryColor,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        25.verticalSpace,
                        Container(height: 1.h, color: dividerColor),
                        // 18.verticalSpace,
                        (notifier.currentLocation.isEmpty ||
                                notifier.currentLocation.length == 0)
                            ? Center(
                                child: Text(
                                  'No Active Employees',
                                  style: bodyMedium.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: theme.primaryColor,
                                  ),
                                ),
                              )
                            : Expanded(
                                child: GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount:
                                              3, // number of items in each row
                                          mainAxisSpacing:
                                              10.0.w, // spacing between rows
                                          crossAxisSpacing:
                                              16.0.h, // spacing between columns
                                          childAspectRatio: 80 / 70),
                                  shrinkWrap: true,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 20),
                                  itemCount: notifier.currentLocation.length,
                                  itemBuilder: (context, index) {
                                    var item = notifier.currentLocation[index];
                                    return GestureDetector(
                                      onTap: () {
                                        notifier.tapOnEmployee(
                                            userId: item.userId ?? '',
                                            lat: item.latitude ?? 0.0,
                                            lng: item.longitude ?? 0.0);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.08),
                                                  blurRadius: 4,
                                                  offset: const Offset(0, 4),
                                                ),
                                              ] 
                                        ),
                                        child: Column(
                                          children: [
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: Container(
                                                height: 9,
                                                width: 9,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: onlineGreenColor),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 32.w,
                                                  height: 32.h,
                                                  decoration: BoxDecoration(
                                                    color: theme
                                                        .scaffoldBackgroundColor,
                                                    // borderRadius: BorderRadius.circular(12.r),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      item.employeeName
                                                              ?.getFirstTwoLetters() ??
                                                          'EP',
                                                      style:
                                                          bodyMedium.copyWith(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color:
                                                            theme.primaryColor,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            8.verticalSpace,
                                            Text(
                                              item.employeeName?.firstWord ??
                                                  '',
                                              overflow: TextOverflow.ellipsis,
                                              style: bodyMedium,
                                            ),
                                            5.verticalSpace,
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
