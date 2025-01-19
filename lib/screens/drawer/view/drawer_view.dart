import 'package:employee_location_tracking_app/screens/drawer/provider/drawer_provider.dart';
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
                      Text(StaticInfo.userModel?.email ?? '',
                          style: bodySmall.copyWith(
                              // color: Theme.of(context).primaryColor,
                              )),
                      Spacer(),
                      // 520.verticalSpace,
                      GestureDetector(
                        onTap: () {
                          notifier.logout(context);
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.logout,
                              color: Theme.of(context).primaryColor,
                            ),
                            16.horizontalSpace,
                            Text(
                              'Logout',
                              style: bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                                // color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
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

// class CustomDrawer extends StatelessWidget {

// }
