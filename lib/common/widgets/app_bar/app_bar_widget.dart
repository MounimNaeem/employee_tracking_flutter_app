import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:employee_location_tracking_app/utils/theme/font_styles/light_font_style/light_font_style.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String userName;
  final VoidCallback? onMenuPressed;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const CustomAppBar({
    Key? key,
    required this.userName,
    this.onMenuPressed,
    this.scaffoldKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      // forceMaterialTransparency: true,
      // elevation: 0,
      title: Text(
        userName,
        style: headingMedium.copyWith(
          fontSize: 24.sp,
          color: Theme.of(context).primaryColor,
        ),
      ),
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          size: 24.sp,
          color: Theme.of(context).primaryColor,
        ),
        onPressed: () {
          if (onMenuPressed != null) {
            onMenuPressed!();
          } else if (scaffoldKey != null) {
            scaffoldKey!.currentState?.openDrawer();
          }
        },
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(80.h);
}
