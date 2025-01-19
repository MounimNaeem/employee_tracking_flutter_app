import 'package:employee_location_tracking_app/screens/auth/login/view/login_view.dart';
import 'package:employee_location_tracking_app/screens/auth/signup/view/signup_view.dart';
import 'package:employee_location_tracking_app/screens/splash/view/splash_view.dart';
import 'package:employee_location_tracking_app/utils/enums/enums.dart';
import 'package:employee_location_tracking_app/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ProviderScope(child: const MyApp()));
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