import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class SendNotificationProvider extends ChangeNotifier {
  final String projectId = 'emplooye-tracking-app';
  final String serviceAccountPath = 'assets/service-account.json';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetch the FCM Token of the Admin from Firestore
  Future<String?> getAdminFCMToken() async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('admin_tokens').doc('admin').get();

      if (snapshot.exists) {
        return snapshot['fcm_token'];
      } else {
        print("⚠️ No admin token found in Firestore!");
        return null;
      }
    } catch (e) {
      print("❌ Error fetching admin token: $e");
      return null;
    }
  }

  /// Load service account JSON for authentication
  // Future<Map<String, dynamic>> _loadServiceAccountJson(
  //     BuildContext cntxt) async {
  //   try {
  //     // In a real app, you'd need to securely store and load this file
  //     // This is a simplified example
  //     final data =
  //         await DefaultAssetBundle.of(cntxt).loadString(serviceAccountPath);
  //     return json.decode(data);
  //   } catch (e) {
  //     print('Error loading service account: $e');
  //     rethrow;
  //   }
  // }

  Future<Map<String, dynamic>> _loadServiceAccountJson() async {
    try {
      print('loading service account 888888888888888888888888888888888');
      final data = await rootBundle.loadString(serviceAccountPath);
      return json.decode(data);
    } catch (e) {
      print('Error loading service account: $e');
      rethrow;
    }
  }

  /// Get access token for Firebase Cloud Messaging API
  Future<String> _getAccessToken() async {
    try {
      final serviceAccountJson = await _loadServiceAccountJson();
      final serviceAccountCredentials =
          ServiceAccountCredentials.fromJson(serviceAccountJson);
      final client = await clientViaServiceAccount(serviceAccountCredentials,
          ['https://www.googleapis.com/auth/firebase.messaging']);

      return client.credentials.accessToken.data;
    } catch (e) {
      print('❌ Error getting access token: $e');
      rethrow;
    }
  }

  /// Send Push Notification to Admin
  Future<void> sendPushNotification(
      {required String title,
      required String body,
      }) async {
    try {
      String? adminToken = await getAdminFCMToken();

      if (adminToken == null) {
        print("⚠️ Cannot send notification. No admin token found!");
        return;
      }

      final accessToken = await _getAccessToken();
      final fcmUrl =
          'https://fcm.googleapis.com/v1/projects/$projectId/messages:send';

      final Map<String, dynamic> message = {
        'message': {
          'token': adminToken,
          'notification': {
            'title': title,
            'body': body,
          },
          'android': {
            'priority': 'HIGH',
          },
          'apns': {
            'headers': {
              'apns-priority': '10',
            },
          },
        }
      };

      final response = await http.post(
        Uri.parse(fcmUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(message),
      );

      print('📩 Status code: ${response.statusCode}');
      print('📨 Response body: ${response.body}');

      if (response.statusCode == 200) {
        print('✅ Notification sent successfully!');
      } else {
        print('❌ Failed to send notification: ${response.statusCode}');
        print('⚠️ Error: ${response.body}');
      }
    } catch (e) {
      print('❌ Error sending notification: $e');
    }
  }
}
