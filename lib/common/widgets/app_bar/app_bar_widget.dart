import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:employee_location_tracking_app/utils/theme/font_styles/light_font_style/light_font_style.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String userName;
  final VoidCallback? onMenuPressed;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final bool showBackIcon;
  final List<Widget>? actionWidget;
  final Color? color;

  const CustomAppBar({
    Key? key,
    required this.userName,
    this.showBackIcon = false,
    this.onMenuPressed,
    this.actionWidget,
    this.scaffoldKey,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor:color ?? Colors.transparent,
      // forceMaterialTransparency: true,
      // elevation: 0,
      title: Text(
        userName,
        style: headingMedium.copyWith(
          fontSize: 24.sp,
          color: Theme.of(context).primaryColor,
        ),
      ),
      leading: (showBackIcon)
          ? IconButton(
              icon: Icon(
                Icons.arrow_back_outlined,
                size: 24.sp,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          : IconButton(
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
            actions: actionWidget != null ? actionWidget : [],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(80.h);
}
