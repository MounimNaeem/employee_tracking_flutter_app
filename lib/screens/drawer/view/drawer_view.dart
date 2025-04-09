import 'package:employee_location_tracking_app/screens/admin_dashboard/models/employee_list_model.dart';
import 'package:employee_location_tracking_app/screens/drawer/provider/drawer_provider.dart';
import 'package:employee_location_tracking_app/screens/employee_dashboard/provider/employee_provider.dart';
import 'package:employee_location_tracking_app/screens/employee_history/view/employee_history_view.dart';
import 'package:employee_location_tracking_app/screens/update_password/view/update_password_view.dart';
import 'package:employee_location_tracking_app/services/admin_background_service/admin_background_service.dart';
import 'package:employee_location_tracking_app/services/background_service_manager/backgroung_service_manager.dart';
import 'package:employee_location_tracking_app/services/shared_prefs_service.dart';
import 'package:employee_location_tracking_app/utils/enums/enums.dart';
import 'package:employee_location_tracking_app/utils/static_info/static_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:employee_location_tracking_app/utils/theme/font_styles/light_font_style/light_font_style.dart';

class DrawerView extends ConsumerStatefulWidget {
  const DrawerView({Key? key}) : super(key: key);

  @override
  ConsumerState<DrawerView> createState() => _DrawerViewState();
}

class _DrawerViewState extends ConsumerState<DrawerView> {
  final provider = ChangeNotifierProvider((ref) => DrawerProvider());

  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(provider);
    return SizedBox(
        width: 297.w,
        child: Drawer(
            child: Container(
          color: Theme.of(context).cardColor,
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      60.verticalSpace,
                      Stack(
                        children: [
                          Container(
                              width: 81,
                              height: 81,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Theme.of(context).primaryColor,
                                    width: 2),
                              ),
                              child: Icon(Icons.person_outline,
                                  color: Theme.of(context).primaryColor,
                                  size: 60)),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).primaryColor,
                              ),
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      10.verticalSpace,
                      Text(
                        StaticInfo.userModel?.fullName ?? '',
                        style: bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      8.verticalSpace,
                      Text(
                        StaticInfo.userModel?.email ?? '',
                        style: bodySmall.copyWith(
                            // color: Theme.of(context).primaryColor,
                            ),
                      ),
                      16.verticalSpace,
                      DrawerItemWidget(
                        icon: Icons.lock,
                        title: 'Update Password',
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdatePasswordView(),
                            )),
                      ),
                      if (StaticInfo.userModel?.userType ==
                          UserType.employee) ...[
                        24.verticalSpace,
                        DrawerItemWidget(
                            icon: Icons.history,
                            title: 'History',
                            onTap: () {
                              EmployeeListModel employee = EmployeeListModel(
                                  id: StaticInfo.userModel?.userId ?? '',
                                  firstName:
                                      StaticInfo.userModel?.firstName ?? '',
                                  lastName:
                                      StaticInfo.userModel?.lastName ?? '',
                                  phone: StaticInfo.userModel?.phone ?? '',
                                  email: StaticInfo.userModel?.email ?? '',
                                  isActive: true,
                                  profileImage:
                                      StaticInfo.userModel?.profileImage ?? '',
                                  userUid: StaticInfo.userModel?.userUid ?? '',
                                  userId: StaticInfo.userModel?.userId ?? '',
                                  userType: StaticInfo.userModel?.userType ??
                                      UserType.admin);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EmployeeHistoryView(
                                      employee: employee,
                                      employeeName:
                                          StaticInfo.userModel?.fullName ??
                                              'History',
                                      userId:
                                          StaticInfo.userModel?.userId ?? '',
                                    ),
                                  ));
                            }),
                      ],
                      if (StaticInfo.userModel?.userType == UserType.admin) ...[
                        24.verticalSpace,
                        ToggleDrawerItemWidget(
                          icon: Icons.notifications,
                          title: "Notification",
                          initialValue:
                              StaticInfo.getIsAdminBackgroundServiceOn ?? false,
                          onToggle: (bool isOn) async {
                            // Perform your tasks based on toggle state
                            if (isOn) {
                              print('88888888888 $isOn');
                              await BackgroundServicesManager
                                  .startAdminService();
                              SharedPrefsService()
                                  .setIsAdminBackgroundServiceOn(isOn);
                              // Task when toggle is turned on
                            } else {
                              print('999999999999999999 $isOn');
                              await BackgroundServicesManager
                                  .stopAdminService();
                              SharedPrefsService()
                                  .setIsAdminBackgroundServiceOn(isOn);
                              // Task when toggle is turned off
                            }
                          },
                          onTap: () {},
                        ),
                      ],
                      Spacer(),
                      // 520.verticalSpace,
                      DrawerItemWidget(
                        icon: Icons.logout,
                        title: 'Logout',
                        onTap: () => notifier.logout(context),
                      ),
                      16.verticalSpace,
                    ],
                  ),
                ),
              ),
              Container(
                height: 2,
                color: Colors.black,
              ),
              133.verticalSpace,
            ],
          ),
        )));
  }
}

class DrawerItemWidget extends StatelessWidget {
  const DrawerItemWidget({
    super.key,
    required this.onTap,
    required this.icon,
    required this.title,
  });

  final Function() onTap;
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      // () {
      //   EmployeeNotifier().disposeData();
      //   notifier.logout(context);
      // },
      child: Row(
        children: [
          Icon(
            icon,
            color: Theme.of(context).primaryColor,
            size: 20,
          ),
          10.horizontalSpace,
          Text(
            title,
            style: bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
              // color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

class ToggleDrawerItemWidget extends StatefulWidget {
  const ToggleDrawerItemWidget({
    Key? key,
    required this.onTap,
    required this.icon,
    required this.title,
    required this.onToggle,
    this.initialValue = false,
  }) : super(key: key);

  final VoidCallback onTap;
  final IconData icon;
  final String title;
  final ValueChanged<bool> onToggle;
  final bool initialValue;

  @override
  _ToggleDrawerItemWidgetState createState() => _ToggleDrawerItemWidgetState();
}

class _ToggleDrawerItemWidgetState extends State<ToggleDrawerItemWidget> {
  late bool _isToggled;

  @override
  initState() {
    super.initState();
    _isToggled = widget.initialValue;
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        // initialToggledValue();
      },
    );
  }

  Future<void> initialToggledValue() async {
    _isToggled = await SharedPrefsService().getIsAdminBackgroundServiceOn();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: widget.onTap,
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                widget.icon,
                color: theme.primaryColor,
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(
                widget.title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Spacer(),
          Switch(
            activeColor: theme.primaryColor,
            activeTrackColor: theme.scaffoldBackgroundColor,
            inactiveTrackColor: theme.scaffoldBackgroundColor,
            inactiveThumbColor: theme.colorScheme.secondary,
            value: _isToggled,
            onChanged: (bool value) {
              setState(() {
                _isToggled = value;
              });
              // Call the provided onToggle callback with the new value.
              widget.onToggle(value);
            },
          ),
        ],
      ),
    );
  }
}
