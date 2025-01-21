import 'package:cloud_firestore/cloud_firestore.dart';

class Location {
  final String address;
  final double latitude;
  final double longitude;
  final double accuracy;
  final double speed;
  final DateTime timestamp;

  Location({
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    required this.speed,
    required this.timestamp,
  });

  // Factory method to create a Location from Firestore data
  factory Location.fromMap(Map<String, dynamic> data) {
    return Location(
      address: data['address'] ?? '',
      latitude: data['latitude'] ?? 0.0,
      longitude: data['longitude'] ?? 0.0,
      accuracy: data['accuracy'] ?? 0.0,
      speed: data['speed'] ?? 0.0,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }
}


class DateHistory {
  final String date; // YYYY-MM-DD format
  final List<Location> locations;

  DateHistory({
    required this.date,
    required this.locations,
  });
}
