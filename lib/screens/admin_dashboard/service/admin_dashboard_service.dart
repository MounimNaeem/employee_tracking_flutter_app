import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDashboardService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    try {
      final QuerySnapshot querySnapshot =
          await _firestore.collection('users').get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        
        return data;
        // {
        //   'id': doc.id,
        //   ...data,
        // };
      }).toList();
    } catch (e) {
      print('Error fetching users: $e');
      throw Exception('Failed to fetch users');
    }
  }
}
