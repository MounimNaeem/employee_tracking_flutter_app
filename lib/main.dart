import 'dart:ui';

import 'package:employee_location_tracking_app/screens/auth/login/view/login_view.dart';
import 'package:employee_location_tracking_app/screens/auth/signup/view/signup_view.dart';
import 'package:employee_location_tracking_app/screens/employee_history/models/employee_location_history_model.dart';
import 'package:employee_location_tracking_app/screens/splash/view/splash_view.dart';
import 'package:employee_location_tracking_app/services/firebase_notification/notification_messages_handler.dart';
import 'package:employee_location_tracking_app/utils/enums/enums.dart';
import 'package:employee_location_tracking_app/utils/static_info/static_info.dart';
import 'package:employee_location_tracking_app/utils/theme/theme.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'firebase_options.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';


Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('dddddddddddddddddd ${message.data}');
  // NotificationMessagesHandler().onNotificationReceived(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeService();
  fcmToken();

  runApp(ProviderScope(child: const MyApp()));
}

void fcmToken() async {
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
  );
  String? token = await FirebaseMessaging.instance.getToken();
  print('fcm token is $token');
  StaticInfo.fcmToken = token;
  NotificationMessagesHandler().initialize();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}


Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
    ),
  );

  service.startService();
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) {
  DartPluginRegistrant.ensureInitialized();
  // Location location = Location();

  // Timer.periodic(const Duration(minutes: 1), (timer) async {
  //   LocationData? currentLocation = await location.getLocation();
  //   print(
  //       'Background location updated: ${currentLocation.latitude}, ${currentLocation.longitude}');

  //   // TODO: Send the updated location to Firestore
  // });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(414, 869),
        minTextAdapt: false,
        builder: (_, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: AppTheme.getTheme(),
            themeMode: ThemeMode.light,
            darkTheme: AppTheme.getTheme(theme: AllThemes.dark),
            home: SplashView(),
          );
        });
  }
}
