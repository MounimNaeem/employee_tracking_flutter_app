import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

class NotificationMessagesHandler {
  // Singleton instance of the notifications plugin
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static late AndroidNotificationChannel _channel;

  void initialize() async {
    await _setupLocalNotifications();
    await _requestPermissions();
    _onForegroundNotificationReceive();
    _tapOnNotifications();
  }

  /// **1. Setup Local Notifications**
  Future<void> _setupLocalNotifications() async {
    _channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
      showBadge: true,
    );

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onForeGroundNotificationTap,
    );

    // Create the channel for Android (API 26+)
    final AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
    );

    final AndroidNotificationChannelGroup channelGroup =
        AndroidNotificationChannelGroup(
            'high_importance_channel_group', 'General');

    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: channel.description,
      importance: channel.importance,
      priority: Priority.high,
      showWhen: true,
      playSound: true,
      enableVibration: true,
      channelShowBadge: true,
      icon: '@mipmap/ic_launcher',
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    print('Local notification channel created successfully.');
  }

  /// **2. Request Permissions**
  Future<void> _requestPermissions() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');

    // Android 13+ specific permission
    // if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    //   _requestAndroidPermission();
    // }
  }

  /// **3. Handle Foreground Notifications**
  void _onForegroundNotificationReceive() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Notification received: ${message.notification?.title}');

      if (message.notification != null) {
        _showNotification(message);
      }
    });
  }

  /// **4. Show Local Notification**
  Future<void> _showNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    Map<String, dynamic>? notificationData = message.data;

    if (notification != null && android != null) {
      await _flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _channel.id,
            _channel.name,
            channelDescription: _channel.description,
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
            channelShowBadge: true,
            icon: '@mipmap/ic_launcher', // Ensure this icon exists
          ),
        ),
        payload: jsonEncode(notificationData),
      );
    }
  }

  /// **5. Handle Tapping on Notifications**
  void _tapOnNotifications() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification clicked: ${message.data}');
      _handleNotificationAction(message.data);
    });

    _flutterLocalNotificationsPlugin
        .getNotificationAppLaunchDetails()
        .then((details) {
      if (details != null && details.didNotificationLaunchApp) {
        final String? payload = details.notificationResponse?.payload;
        if (payload != null) {
          Map<String, dynamic> data = jsonDecode(payload);
          _handleNotificationAction(data);
        }
      }
    });
  }

  void _handleNotificationAction(Map<String, dynamic> data) {
    print('Handling notification action for: ${data['view']}');
    // Implement your navigation logic here
  }

  void _onForeGroundNotificationTap(NotificationResponse response) {
    if (response.payload != null) {
      Map<String, dynamic> data = jsonDecode(response.payload!);
      _handleNotificationAction(data);
    }
  }
}






























// import 'dart:convert';

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';



// class NotificationMessagesHandler {
//   // HomeViewModel homeViewModel = locator<HomeViewModel>();

//   void initialize() {
//     onForegroundNotificationReceive();
//     tapOnNotifications();
//   }

//   void onForegroundNotificationReceive() async {
//     print('notification received in foreground');
//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//       'high_importance_channel', // id
//       'High Importance Notifications', // title
//       showBadge: true,
//       //'This channel is used for important notifications.', // description
//       importance: Importance.max,
//     );
//     final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//         FlutterLocalNotificationsPlugin();

//     var initializationSettingsAndroid =
//         const AndroidInitializationSettings('@mipmap/notification_icon');
//     final DarwinInitializationSettings initializationSettingsDarwin =
//         DarwinInitializationSettings(
//       requestSoundPermission: false,
//       requestBadgePermission: false,
//       requestAlertPermission: false,
//       //onDidReceiveLocalNotification: onDidReceiveLocalNotification,
//     );
//     var initializationSettings = new InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsDarwin,
//     );
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onDidReceiveNotificationResponse: onForeGroundNotificationTap);

//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print(
//           'Just received a notification when driver app is in use   ${message.data['view']}');
//       onNotificationReceived(message);
//       RemoteNotification? notification = message.notification;
//       AndroidNotification? android = message.notification?.android;
//       Map<String, dynamic>? notificationData = message.data;

//       // If `onMessage` is triggered with a notification, construct our own
//       // local notification to show to users using the created channel.
//       if (notification != null && android != null) {
//         //onNotificationTap(message.data['view']);
//         flutterLocalNotificationsPlugin.show(
//           notification.hashCode,
//           notification.title,
//           notification.body,
//           NotificationDetails(
//             android: AndroidNotificationDetails(
//               channel.id,
//               channel.name,
//               channelShowBadge: channel.showBadge,
//               icon: android.smallIcon,
//               importance: Importance.max,
//               priority: Priority.high,
//             ),
//           ),
//           payload:
//               notificationData != null ? jsonEncode(notificationData) : null,
//         );
//       }
//     });
//   }

//   void tapOnNotifications() {
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       // actionToBePerformOnClick(message.data['view']);
//     });
//   }

//   // void actionToBePerformOnClick(String val) {
//   //   switch (val) {
//   //     case 'driverApproval':
//   //       {
//   //         print('driver approved many times');
//   //         HomeViewModel homeViewModel = locator<HomeViewModel>();
//   //         homeViewModel.profileApprovalStatus();
//   //       }
//   //       break;
//   //     case 'makeAnOfferScreen':
//   //       {
//   //         print('new offer received');
//   //         BottomBarViewModel bottomBarViewModel =
//   //         locator<BottomBarViewModel>();
//   //         bottomBarViewModel.pageController?.jumpTo(0);
//   //         bottomBarViewModel.newPageNo(0);
//   //       }
//   //       break;
//   //   }
//   // }

//   void onForeGroundNotificationTap(NotificationResponse data) {
//     var decodedData = json.decode(data.payload!);
//     // actionToBePerformOnClick(decodedData['view']);
//     // switch(decodedData['view']){
//     //   case 'driverApproval':{
//     //       homeViewModel.profileApprovalStatus();
//     //   }break;
//     // }
//   }

//   void onNotificationReceived(RemoteMessage message) {
//     print('on notification method call ${message} ');
//   //   switch (message.data['view']) {
//   //     case 'driverApproval':
//   //       {
//   //         if(GetIt.instance.isRegistered<HomeViewModel>() == false){
//   //           GetIt.instance
//   //               .registerSingleton<HomeViewModel>(HomeViewModel())
//   //               .profileApprovalStatus();
//   //         }
//   //         else{
//   //           HomeViewModel homeViewModel1 = locator<HomeViewModel>();
//   //           homeViewModel1.profileApprovalStatus();
//   //         }
//   //         // locator<HomeViewModel>().profileApprovalStatus();
//   //         //  HomeViewModel homeViewModel1 = locator<HomeViewModel>();
//   //         // homeViewModel1.profileApprovalStatus();
//   //       }
//   //       break;
//   //   }
//   // }
// }
// }
