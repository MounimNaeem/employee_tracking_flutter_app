import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_location_tracking_app/screens/employee_history/models/employee_location_history_model.dart';

class EmployeeHistoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<dynamic> fetchAllHistories(String userId) async {
    try {
      // Reference to the dates sub-collection
      final datesCollection = _firestore
          .collection('histories') // Top-level collection
          .doc(userId) // Document for the user
          .collection('dates'); // Sub-collection for dates

      // Fetch all documents in the dates sub-collection
      final querySnapshot = await datesCollection.get();

      // List to store all grouped histories
      List<DateHistory> groupedHistories = [];

      for (final dateDoc in querySnapshot.docs) {
        // Fetch the locations sub-collection for each date
        final locationsSnapshot =
            await dateDoc.reference.collection('locations').get();

        // Convert each location document into a Location model
        List<Location> locations = locationsSnapshot.docs.map((locationDoc) {
          return Location.fromMap(locationDoc.data());
        }).toList();

        // Add the date and its associated locations to the groupedHistories list
        groupedHistories.add(DateHistory(
          date: dateDoc.id, // Use the document ID as the date
          locations: locations,
        ));
      }

      return groupedHistories;
    } catch (e) {
      print('Error fetching and grouping histories: $e');
      return [];
    }
  }

//   try {
//     // Reference to the dates sub-collection
//     final datesCollection = _firestore
//         .collection('histories') // Top-level collection
//         .doc(userId) // Document for the user
//         .collection('dates'); // Sub-collection for dates

//     // Fetch all documents in the dates sub-collection
//     final querySnapshot = await datesCollection.get();

//     // List to store all location data
//     List<Map<String, dynamic>> allHistories = [];

//     for (final dateDoc in querySnapshot.docs) {
//       // Fetch the locations sub-collection for each date
//       final locationsSnapshot = await dateDoc.reference.collection('locations').get();

//       for (final locationDoc in locationsSnapshot.docs) {
//         // Add each location document along with its date
//         print('location data location data  ${locationDoc.data()}');
//         allHistories.add({
//           'date': dateDoc.id, // The date of the document
//           'location': locationDoc.data(), // Location data
//         });
//       }
//     }

//     return allHistories;
//   } catch (e) {
//     print('Error fetching histories: $e');
//     return [];
//   }
// }
}
