import 'dart:async';
import 'package:employee_location_tracking_app/main.dart';
import 'package:employee_location_tracking_app/utils/app_utils/app_utils.dart';
import 'package:employee_location_tracking_app/utils/theme/font_styles/light_font_style/light_font_style.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Global PermissionManager provider
final permissionManagerProvider =
    ChangeNotifierProvider<PermissionManager>((ref) {
  final manager = PermissionManager(ref);
  PermissionManager.instance = manager;
  return manager;
});

class PermissionManager extends ChangeNotifier {
  static PermissionManager? instance;
  final Ref ref;
  bool _hasBackgroundPermission = false;

  bool get hasBackgroundPermission => _hasBackgroundPermission;

  PermissionManager(this.ref) {
    print('PermissionManager created');
  }

  @override
  void dispose() {
    instance = null;
    super.dispose();
    print('PermissionManager disposed');
  }

  // Public method to check permission and navigate, using provided context
  Future<void> checkPermissionAndNavigate(BuildContext context) async {
    print('Checking permission manually with provided context...');
    await _checkAndEnforcePermission(context);
  }

  Future<void> _checkAndEnforcePermission(BuildContext context) async {
    try {
      print('Checking permissions...');
      bool serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('Location services disabled');
        _showSnackBar('Location services are disabled. Please enable them.');
        await _showPermissionDialog(context);
        _hasBackgroundPermission = false;
        notifyListeners();
        return;
      }

      geo.LocationPermission permission =
          await geo.Geolocator.checkPermission();
      print('Current permission: $permission');

      if (permission == geo.LocationPermission.denied) {
        print('Permission denied, requesting...');
        permission = await geo.Geolocator.requestPermission();
        if (permission == geo.LocationPermission.denied) {
          print('Permission denied after request');
          _showSnackBar('Location permission denied.');
          await _showPermissionDialog(context);
          _hasBackgroundPermission = false;
          notifyListeners();
          return;
        }
      }

      if (permission == geo.LocationPermission.deniedForever) {
        print('Permission denied forever');
        _showSnackBar(
            'Location permission permanently denied. Please enable in settings.');
        await _showPermissionDialog(context);
        _hasBackgroundPermission = false;
        notifyListeners();
        return;
      }

      if (permission != geo.LocationPermission.always) {
        print('Permission is not "always": $permission');
        _hasBackgroundPermission = false;
        await _showBackgroundPermissionScreen(context);
      } else {
        print('Permission is "always"');
        _hasBackgroundPermission = true;
        if (Navigator.canPop(context)) {
          print('Popping BackgroundPermissionScreen if present');
          Navigator.pop(context);
        }
      }
      notifyListeners();
    } catch (e) {
      print('Error checking permissions: $e');
      _hasBackgroundPermission = false;
      _showSnackBar('Error checking permissions: $e');
      notifyListeners();
    }
  }

  void _showSnackBar(String message) {
    print('Showing SnackBar: $message');
    scaffoldMessengerKey.currentState?.removeCurrentSnackBar();
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _showPermissionDialog(BuildContext context) async {
    print('Showing permission dialog');
    await AppUtils.showConfirmationDialog(
      context: context,
      title: 'Location Permission Required',
      message:
          "Employee Tracking needs location access to function. Please grant permission.",
      onConfirm: () {
        print('Opening app settings from dialog');
        Navigator.pop(context);
        geo.Geolocator.openAppSettings();
      },
      confirmText: 'Open Settings',
    );
  }

  Future<void> _showBackgroundPermissionScreen(BuildContext context) async {
    print('Navigating to BackgroundPermissionScreen');
    if (ModalRoute.of(context)?.settings.name != 'BackgroundPermissionScreen') {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const BackgroundPermissionScreen(),
          settings: const RouteSettings(name: 'BackgroundPermissionScreen'),
        ),
      );
    } else {
      print('Already on BackgroundPermissionScreen');
    }
  }
}

class BackgroundPermissionScreen extends StatelessWidget {
  const BackgroundPermissionScreen({super.key});

  Future<void> _showDisclosureDialog(BuildContext context) async {
    print('Showing disclosure dialog');
    bool? accepted = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Location Access Notice'),
        content: const Text(
          'Employee Tracking collects location data to enable real-time tracking, even when the app is closed or not in use.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              print('Disclosure dialog: Deny');
              Navigator.of(context).pop(false);
            },
            child: const Text('Deny'),
          ),
          TextButton(
            onPressed: () {
              print('Disclosure dialog: Accept');
              Navigator.of(context).pop(true);
              Navigator.of(context).pop(true);
            },
            child: const Text('Accept'),
          ),
        ],
      ),
    );

    if (accepted == true) {
      print('Opening app settings from disclosure');
      await geo.Geolocator.openAppSettings();
    } else {
      print('Background permission denied');
      scaffoldMessengerKey.currentState?.showSnackBar(
        const SnackBar(
          content: Text('Background location access is required.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Building BackgroundPermissionScreen');
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 36.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 90.verticalSpace,
              // Image.asset(
              //   'assets/images/location_permossion.png',
              //   width: 200.w,
              //   height: 200.h,
              // ),
              // 50.verticalSpace,
              Text(
                "Background Location Required",
                style: headingMedium.copyWith(
                  color: Colors.black,
                  fontSize: 18.sp,
                ),
              ),
              16.verticalSpace,
              Text(
                "Employee Tracking requires 'Allow All The Time' location access to share your live location with the server for real-time tracking. Please enable it in settings.",
                textAlign: TextAlign.center,
                style: bodyMedium,
              ),
              56.verticalSpace,
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 48.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                onPressed: () async {
                  print('Button pressed: Go to Settings');
                  await _showDisclosureDialog(context);
                  await PermissionManager.instance
                      ?._checkAndEnforcePermission(context);
                },
                child: const Text('Go to Settings'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
