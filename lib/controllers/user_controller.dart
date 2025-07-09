import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppUser {
  String? firstName;
  String? lastName;
  String? goal;
  double? weight;
  double? height;
  int? age;
  double? bmi;

  AppUser({
    this.firstName,
    this.lastName,
    this.goal,
    this.weight,
    this.height,
    this.age,
    this.bmi,
  });

  factory AppUser.fromFirestore(Map<String, dynamic> data) {
    final double? height = (data['height'] is int)
        ? (data['height'] as int).toDouble()
        : data['height'];
    final double? weight = (data['weight'] is int)
        ? (data['weight'] as int).toDouble()
        : data['weight'];

    double? bmi;
    if (height != null && weight != null && height > 0) {
      final heightInMeters = height / 100;
      bmi = weight / (heightInMeters * heightInMeters);
    }

    return AppUser(
      firstName: data['first_name'],
      lastName: data['last_name'],
      goal: data['goal'],
      weight: weight,
      height: height,
      age: data['age'],
      bmi: bmi,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'goal': goal,
      'weight': weight,
      'height': height,
      'age': age,
    };
  }
}

class UserController extends GetxController {
  final Rx<AppUser?> _user = Rx<AppUser?>(null);
  final RxBool _notificationEnabled = false.obs;
  bool get notificationEnabled => _notificationEnabled.value;

  AppUser? get user => _user.value;

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

   Future<void> toggleNotification(bool val) async {
    _notificationEnabled.value = !_notificationEnabled.value;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notification_enabled', _notificationEnabled.value);
  }

  Future<void> loadNotificationPreference() async {
    final prefs = await SharedPreferences.getInstance();
    final savedValue = prefs.getBool('notification_enabled') ?? false;
    _notificationEnabled.value = savedValue;
  }

   void onInit() {
    super.onInit();
    loadNotificationPreference();
    fetchUserProfileFromFirestore(); // 🔃 Load toggle state
  }

  /// Fetch user profile from Firestore and store in `_user`
  Future<void> fetchUserProfileFromFirestore() async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) return;

      final snapshot = await _firestore.collection('users').doc(uid).get();
      if (snapshot.exists && snapshot.data() != null) {
        final userData = snapshot.data()!;
        _user.value = AppUser.fromFirestore(userData);
      }
    } catch (e) {
      print("Error fetching user profile: $e");
    }
  }

  /// Update user profile in Firestore and refresh controller
  Future<void> updateUserProfile(AppUser updatedUser) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) return;

      await _firestore
          .collection('users')
          .doc(uid)
          .set(updatedUser.toFirestore(), SetOptions(merge: true));

      // Update local state
      _user.value = updatedUser;
      update(); // force refresh for widgets using GetBuilder if any
    } catch (e) {
      print("Error updating profile: $e");
    }
  }
}
