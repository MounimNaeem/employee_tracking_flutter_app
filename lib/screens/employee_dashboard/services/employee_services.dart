import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_location_tracking_app/services/firebase_notification/provider/send_notification_provider.dart';
import 'package:employee_location_tracking_app/utils/static_info/static_info.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class EmployeeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Updates the live location of the user in Firestore.
  Future<void> updateLiveLocation(
      String userId, Position position, String address, bool isOnline) async {
    String formattedDateTime =
        DateFormat('dd MMM yyyy hh:mm a').format(DateTime.now());
    try {
      await _firestore.collection('liveLocations').doc(userId).set({
        'userId': userId,
        'employeeName': StaticInfo.userModel!.firstName,
        "isActive": isOnline,
        'address': address,
        'latitude': position.latitude,
        'longitude': position.longitude,
        'time': formattedDateTime,
      });
    } catch (e) {
      print('Error updating live location: $e');
    }
  }

  /// Stores the user's location in the location history collection.
  Future<void> storeLocationHistory(String userId, Position position,
      String address, bool isOnline, BuildContext cntxt) async {
    try {
      final String todayDate = DateTime.now().toIso8601String().split('T')[0];

      print('Storing location in separate histories collection');

      // Reference to the user's location history for the specific date
      final docRef = _firestore
          .collection('histories') // Top-level collection
          .doc(userId) // Document for the user
          .collection('dates') // Sub-collection for dates
          .doc(todayDate); // Document for the specific date

      // Check if the document for today's date exists
      final docSnapshot = await docRef.get();

      print('Checking document existence: ${docSnapshot.exists}');

      if (!docSnapshot.exists) {
        // If the document doesn't exist, create it with online time and empty locations
        await docRef.set({
          'date': todayDate,
          'onlineTime': isOnline ? FieldValue.serverTimestamp() : null,
          'offlineTime': null, // Set when employee goes offline
        });
      }

      // Update location data in the locations sub-collection
      await docRef.collection('locations').add({
        'address': address,
        'latitude': position.latitude,
        'longitude': position.longitude,
        'timestamp': FieldValue.serverTimestamp(),
        'accuracy': position.accuracy,
        'speed': position.speed,
      });

      // Update online/offline time
      if (isOnline) {
        await docRef.update({
          'onlineTime': FieldValue.serverTimestamp(),
        });
      } else {
        await docRef.update({
          'offlineTime': FieldValue.serverTimestamp(),
        });
      }

      SendNotificationProvider().sendPushNotification(
        body:
            '${StaticInfo.userModel?.firstName}\'s location has been updated. Check the latest details in the app',
        title: '📌 Employee Location Updated',
        cntxt: cntxt,
      );
    } catch (e) {
      print('Error storing location history: $e');
    }
  }

  Future<void> updateEmployeeActiveStatusInUserDoc(
      bool isOnline, BuildContext cntxt) async {
    try {
      // Update online status in the user document
      print('Updating online status in user document $isOnline');
      await _firestore
          .collection('users')
          .doc(StaticInfo.userModel!.userUid)
          .update({
        'isActive': isOnline,
      });
      SendNotificationProvider().sendPushNotification(
        body: isOnline
            ? '${StaticInfo.userModel?.firstName} is now online and ready to work.'
            : '${StaticInfo.userModel?.firstName} has gone offline and is unavailable',
        title: isOnline
            ? '🟢 Employee is Now Online'
            : '🔴 Employee is Now Offline',
        cntxt: cntxt,
      );
    } catch (e) {
      print('Error storing location history: $e');
    }
  }

  /// Get current position with high accuracy
  Future<Position> getCurrentPosition() async {
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  /// clear history before 45 days from firebase
  Future<void> cleanHistory(String userId) async {
    try {
      // Get the cutoff date
      final String cutoffDate = DateTime.now()
          .subtract(Duration(days: 45))
          .toIso8601String()
          .split('T')[0];

      print('Cleaning history before: $cutoffDate for user: $userId');

      // Reference to the user's "dates" sub-collection
      final datesRef = FirebaseFirestore.instance
          .collection('histories')
          .doc(userId)
          .collection('dates');

      // Get all documents in the 'dates' sub-collection
      final querySnapshot = await datesRef.get();
      print('querySnapshot.docs.length ${querySnapshot.docs.length}');
      // Iterate through each document in the 'dates' collection
      for (var doc in querySnapshot.docs) {
        // Extract the date from the document ID (which is in YYYY-MM-DD format)
        String date = doc.id;
        print('Checking date: $date');
        // Compare document date with cutoff date
        if (date.compareTo(cutoffDate) < 0) {
          // If the document's date is older than the cutoff date, delete it
          await doc.reference.delete();
          print('Deleted history for date: $date');
        }
      }

      print('History cleanup complete!');
    } catch (e) {
      print('Error cleaning history: $e');
    }
  }
}
