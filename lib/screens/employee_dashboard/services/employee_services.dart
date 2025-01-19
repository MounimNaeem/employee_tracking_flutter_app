import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_location_tracking_app/utils/static_info/static_info.dart';
import 'package:geolocator/geolocator.dart';

class EmployeeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Gets a stream of location updates.
  /// Gets a stream of location updates.
  Stream<Position> getLocationStream({LocationSettings? locationSettings}) {
    return Geolocator.getPositionStream(
      locationSettings: locationSettings ??
          const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter:
                10, // Minimum distance (in meters) to trigger updates
          ),
    );
  }

  /// Updates the live location of the user in Firestore.
  Future<void> updateLiveLocation(
      String userId, Position position, String address) async {
    try {
      await _firestore.collection('liveLocations').doc(userId).set({
        'address': address,
        'latitude': position.latitude,
        'longitude': position.longitude,
        'timestamp': FieldValue.serverTimestamp(),
        'accuracy': position.accuracy,
        'speed': position.speed,
      });
    } catch (e) {
      print('Error updating live location: $e');
    }
  }

  /// Stores the user's location in the location history collection.
  Future<void> storeLocationHistory(
      String userId, Position position, String address, bool isOnline) async {
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

     
     
    } catch (e) {
      print('Error storing location history: $e');
    }
  }


Future<void> updateEmployeeActiveStatusInUserDoc(
      bool isOnline) async {
    try {
     
      // Update online status in the user document
      print('Updating online status in user document $isOnline');
      await _firestore
          .collection('users')
          .doc(StaticInfo.userModel!.userUid)
          .update({
        'isActive': !isOnline,
      });
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
}
