import 'dart:async';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_location_tracking_app/firebase_options.dart';
import 'package:employee_location_tracking_app/services/background_service_manager/backgroung_service_manager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AdminBackgroundService {
  static final _instance = FlutterBackgroundService();
  static FlutterBackgroundService get instance => _instance;

  @pragma('vm:entry-point')
  static void onStart(ServiceInstance service) async {
    DartPluginRegistrant.ensureInitialized();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    if (service is AndroidServiceInstance) {
      service.setAsForegroundService();

      service.on('setAsForeground').listen((event) async {
        await service.setAsForegroundService();
      });

      service.on('setAsBackground').listen((event) async {
        await service.setAsBackgroundService();
      });

      service.on('keepAlive').listen((event) async {
        await service.setForegroundNotificationInfo(
          title: "Employee Tracking Active",
          content: "Monitoring employee status...",
        );
      });
    }

    service.on('stopService').listen((event) async {
      await service.stopSelf();
    });

    Timer.periodic(const Duration(minutes: 15), (timer) async {
      if (service is AndroidServiceInstance) {
        try {
          final prefs = await SharedPreferences.getInstance();
          final isTracking =
              prefs.getBool(BackgroundServicesManager.ADMIN_SERVICE_KEY) ??
                  false;

          if (!isTracking) {
            await service.stopSelf();
            timer.cancel();
            return;
          }

          await service.setForegroundNotificationInfo(
            title: "Employee Tracking Active",
            content: "Monitoring employee status...",
          );

          FirebaseFirestore firestore = FirebaseFirestore.instance;
          DateTime now = DateTime.now();

          QuerySnapshot snapshot = await firestore
              .collection('liveLocations')
              .where('isActive', isEqualTo: true)
              .get();

          for (var doc in snapshot.docs) {
            var data = doc.data() as Map<String, dynamic>;

            try {
              DateTime lastUpdatedTime =
                  DateFormat("dd MMM yyyy hh:mm a").parse(data['time']);
              Duration difference = now.difference(lastUpdatedTime);

              if (difference.inMinutes > 1) {
                await service.setForegroundNotificationInfo(
                  title: "Employee Status Alert 📢",
                  content:
                      "${data['employeeName']} has been inactive for 30+ minutes. Contact them for an update.",
                );
              }
            } catch (e) {
              print(
                  "Error parsing date for ${data['employeeName']}: ${data['time']} - Error: $e");
            }
          }

          service.invoke('keepAlive');
        } catch (e) {
          print('Error in background service: $e');
          await service.setForegroundNotificationInfo(
            title: "Employee Tracking Active",
            content: "Monitoring employee status...",
          );
        }
      }
    });
  }

  static Future<bool> onIosBackground(ServiceInstance service) async {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();
    return true;
  }
}
