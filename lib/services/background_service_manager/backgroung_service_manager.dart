import 'package:employee_location_tracking_app/screens/employee_dashboard/provider/employee_provider.dart';
import 'package:employee_location_tracking_app/services/admin_background_service/admin_background_service.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackgroundServicesManager {
  static const String LOCATION_SERVICE_KEY = 'is_location_tracking_active';
  static const String ADMIN_SERVICE_KEY = 'is_admin_tracking_active';

  static final FlutterLocalNotificationsPlugin _locationNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static final FlutterLocalNotificationsPlugin _adminNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Initialize both services
  static Future<void> initializeServices() async {
    // Initialize location service notifications
    const AndroidInitializationSettings locationInitSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings locationSettings =
        InitializationSettings(android: locationInitSettings);

    await _locationNotificationsPlugin.initialize(locationSettings);

    const AndroidNotificationChannel locationChannel =
        AndroidNotificationChannel(
      'location_tracking_channel',
      'Location Tracking',
      description: 'This channel is used for location tracking notifications',
      importance: Importance.high,
      enableVibration: false,
      showBadge: false,
      enableLights: true,
    );

    await _locationNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(locationChannel);

    // Initialize admin service notifications
    const AndroidInitializationSettings adminInitSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings adminSettings =
        InitializationSettings(android: adminInitSettings);

    await _adminNotificationsPlugin.initialize(adminSettings);

    const AndroidNotificationChannel adminChannel = AndroidNotificationChannel(
      'admin_tracking_channel',
      'Employee Tracking',
      description: 'This channel is used for employee tracking notifications',
      importance: Importance.high,
      enableVibration: false,
      showBadge: false,
      enableLights: true,
    );

    await _adminNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(adminChannel);
  }

  static Future<void> startLocationService() async {
    final service = FlutterBackgroundService();

    // Configure location service
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: BackgroundLocationService.onStart,
        autoStart: false,
        isForegroundMode: true,
        notificationChannelId: 'location_tracking_channel',
        initialNotificationTitle: 'Location Tracking',
        initialNotificationContent: 'Starting location service...',
        foregroundServiceNotificationId: 888,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: false,
        onForeground: BackgroundLocationService.onStart,
        onBackground: BackgroundLocationService.onIosBackground,
      ),
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(LOCATION_SERVICE_KEY, true);
    await service.startService();
  }

  static Future<void> stopLocationService() async {
    final service = FlutterBackgroundService();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(LOCATION_SERVICE_KEY, false);

    bool isRunning = await service.isRunning();
    if (isRunning) {
      service.invoke("stopService");
    }
  }

  static Future<void> startAdminService() async {
    final service = FlutterBackgroundService();

    // Configure admin service
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: AdminBackgroundService.onStart,
        autoStart: false,
        isForegroundMode: true,
        notificationChannelId: 'admin_tracking_channel',
        initialNotificationTitle: 'Employee Tracking',
        initialNotificationContent: 'Starting employee monitoring...',
        foregroundServiceNotificationId: 889,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: false,
        onForeground: AdminBackgroundService.onStart,
        onBackground: AdminBackgroundService.onIosBackground,
      ),
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(ADMIN_SERVICE_KEY, true);
    await service.startService();
  }

  static Future<void> stopAdminService() async {
    final service = FlutterBackgroundService();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(ADMIN_SERVICE_KEY, false);

    bool isRunning = await service.isRunning();
    if (isRunning) {
      service.invoke("stopService");
    }
  }

  static Future<bool> isLocationServiceActive() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(LOCATION_SERVICE_KEY) ?? false;
  }

  static Future<bool> isAdminServiceActive() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(ADMIN_SERVICE_KEY) ?? false;
  }
}
