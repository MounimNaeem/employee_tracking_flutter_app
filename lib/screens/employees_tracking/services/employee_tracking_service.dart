import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeeTrackingService {
   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

   // Stream for live location updates
  Stream<List<Map<String, dynamic>>> streamUserLocation() {
    return _firestore
        .collection('liveLocations')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => doc.data()) // Extract data from each document
            .toList());
  }
}