import 'dart:async';

import 'package:employee_location_tracking_app/screens/splash/view/splash_view.dart';
import 'package:employee_location_tracking_app/services/background_service_manager/backgroung_service_manager.dart';
import 'package:employee_location_tracking_app/services/firebase_notification/notification_messages_handler.dart';
import 'package:employee_location_tracking_app/services/permission_manager/permission_manager.dart';
import 'package:employee_location_tracking_app/utils/enums/enums.dart';
import 'package:employee_location_tracking_app/utils/static_info/static_info.dart';
import 'package:employee_location_tracking_app/utils/theme/theme.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'firebase_options.dart';

final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('dddddddddddddddddd ${message.data}');
  // NotificationMessagesHandler().onNotificationReceived(message);
}

// cJdcETgCTielgBC70cJL7f:APA91bEoo6xlniw5dmqmv5tJ9B0fGCoNGLGU0faGJAn_tLL9ogCuF-4bJkaBLtDi1g804yS19RpEUq_8wMIoVGr_bsNyh9P3JqBwkFYwN5Zg4UdUOKeQlvc?

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // await BackgroundLocationService().initializeService();
  // await AdminBackgroundService().initializeService();

  await BackgroundServicesManager.initializeServices();
  final container = ProviderContainer();
  container.read(permissionManagerProvider);

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
            scaffoldMessengerKey: scaffoldMessengerKey, // Assign here
            // routes: {
            //   BackgroundPermissionScreen.routeName: (context) =>
            //       const BackgroundPermissionScreen(),
            // },
          );
        });
  }
}
