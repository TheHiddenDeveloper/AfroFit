import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveUserProfile({
    required String gender,
    required String dob,
    required String weight,
    required String height,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("No authenticated user");
    }

    final userDoc = _firestore.collection('users').doc(user.uid);

    await userDoc.set({
      'gender': gender,
      'date_of_birth': dob,
      'weight': weight,
      'height': height,
      'email': user.email,
      'uid': user.uid,
      'timestamp': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
