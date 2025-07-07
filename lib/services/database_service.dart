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

  // Save user goal
  Future<void> saveUserGoal(String goal) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) throw Exception("User not logged in");

  await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
    'goal': goal,
    'goal_saved_at': FieldValue.serverTimestamp(),
  }, SetOptions(merge: true));
}


  // Save first and last name
  Future<void> saveUserName({
    required String firstName,
    required String lastName,
  }) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) throw Exception("No logged-in user");

    final userRef = _firestore.collection('users').doc(currentUser.uid);

    await userRef.set({
      'first_name': firstName,
      'last_name': lastName,
    }, SetOptions(merge: true));
  }
}
