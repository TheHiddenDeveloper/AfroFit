import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Save complete profile data
  Future<void> saveUserProfile({
    required String gender,
    required String dateOfBirth,
    required String weight,
    required String height,
  }) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) throw Exception("No logged-in user");

    final userRef = _firestore.collection('users').doc(currentUser.uid);

    await userRef.set({
      'uid': currentUser.uid,
      'email': currentUser.email,
      'gender': gender,
      'date_of_birth': dateOfBirth,
      'weight': weight,
      'height': height,
      'created_at': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
