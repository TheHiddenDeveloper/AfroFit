import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitnessapp/services/sharedPref_service.dart';

/// User data model class
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

  /// Creates AppUser from Firestore document data
  factory AppUser.fromFirestore(Map<String, dynamic> data) {
    // Handle both int and double types for height/weight from Firestore
    final double? height = (data['height'] is int)
        ? (data['height'] as int).toDouble()
        : data['height'];
    final double? weight = (data['weight'] is int)
        ? (data['weight'] as int).toDouble()
        : data['weight'];

    // Calculate BMI if height and weight are available
    double? bmi;
    if (height != null && weight != null && height > 0) {
      final heightInMeters = height / 100; // Convert cm to meters
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

  /// Converts AppUser to Firestore document format
  Map<String, dynamic> toFirestore() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'goal': goal,
      'weight': weight,
      'height': height,
      'age': age,
      // Note: BMI is calculated, not stored in Firestore
    };
  }
}

/// Main controller for managing user data across the app
class UserController extends GetxController {
  // Reactive user data - automatically updates UI when changed
  final Rx<AppUser?> _user = Rx<AppUser?>(null);
  // Reactive notification preference
  final RxBool _notificationEnabled = false.obs;

  // Getters for accessing data
  bool get notificationEnabled => _notificationEnabled.value;
  AppUser? get user => _user.value;

  // Service instances
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final _sharedPrefs = SharedPrefsService();

  /// Toggle notification setting and persist to storage
  Future<void> toggleNotification(bool val) async {
    _notificationEnabled.value = !_notificationEnabled.value;

    // Save notification preference to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notification_enabled', _notificationEnabled.value);
  }

  /// Load notification preference from SharedPreferences
  Future<void> loadNotificationPreference() async {
    final prefs = await SharedPreferences.getInstance();
    final savedValue = prefs.getBool('notification_enabled') ?? false;
    _notificationEnabled.value = savedValue;
  }

  /// GetX lifecycle method - called when controller is initialized
  @override
  void onInit() {
    super.onInit();
    loadNotificationPreference(); // Load notification setting
    loadUserProfile(); // Load user profile data
  }

  /// Main method to load user profile from available sources
  /// Priority: Firestore first, then SharedPreferences as fallback
  Future<void> loadUserProfile() async {
    try {
      // First attempt: Load from Firestore (most up-to-date data)
      await fetchUserProfileFromFirestore();

      // Fallback: If no data in Firestore or data is incomplete, load from SharedPreferences
      if (_user.value == null || (_user.value?.firstName?.isEmpty ?? true)) {
        await loadUserProfileFromSharedPrefs();
      }
    } catch (e) {
      print("Error loading user profile: $e");
      // If Firestore fails, always try SharedPreferences as fallback
      await loadUserProfileFromSharedPrefs();
    }
  }

  /// Load user profile data from SharedPreferences (offline storage)
  Future<void> loadUserProfileFromSharedPrefs() async {
    try {
      // Retrieve all user data from SharedPreferences
      final firstName = await _sharedPrefs.getFirstName();
      final lastName = await _sharedPrefs.getLastName();
      final goal = await _sharedPrefs.getGoal();
      final height = await _sharedPrefs.getHeight();
      final weight = await _sharedPrefs.getWeight();
      final age = await _sharedPrefs.getAge();

      // Only create user object if we have at least basic info (names)
      if (firstName != null || lastName != null) {
        _user.value = AppUser(
          firstName: firstName,
          lastName: lastName,
          goal: goal,
          height: height,
          weight: weight,
          age: age,
        );

        // Calculate BMI if we have height and weight
        if (height != null && weight != null && height > 0) {
          final heightInMeters = height / 100; // Convert cm to meters
          _user.value!.bmi = weight / (heightInMeters * heightInMeters);
        }
      }
    } catch (e) {
      print("Error loading from SharedPreferences: $e");
    }
  }

  /// Fetch user profile from Firestore (cloud storage)
  Future<void> fetchUserProfileFromFirestore() async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) {
        print("No authenticated user found");
        return;
      }

      // Get user document from Firestore
      final snapshot = await _firestore.collection('users').doc(uid).get();
      if (snapshot.exists && snapshot.data() != null) {
        final userData = snapshot.data()!;
        _user.value = AppUser.fromFirestore(userData);
      }
    } catch (e) {
      print("Error fetching user profile from Firestore: $e");
    }
  }

  /// Update user profile in both Firestore and SharedPreferences
  /// This ensures data consistency across storage methods
  Future<void> updateUserProfile(AppUser updatedUser) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) {
        print("No authenticated user found");
        return;
      }

      // Update Firestore with new data (merge: true preserves existing fields)
      await _firestore
          .collection('users')
          .doc(uid)
          .set(updatedUser.toFirestore(), SetOptions(merge: true));

      // Update SharedPreferences with new data
      if (updatedUser.firstName != null && updatedUser.lastName != null) {
        if (updatedUser.height != null &&
            updatedUser.weight != null &&
            updatedUser.age != null &&
            updatedUser.goal != null) {
          // Save complete profile if all fields are available
          await _sharedPrefs.saveUserProfile(
            firstName: updatedUser.firstName!,
            lastName: updatedUser.lastName!,
            height: updatedUser.height!,
            weight: updatedUser.weight!,
            age: updatedUser.age!,
            goal: updatedUser.goal!,
          );
        } else {
          // Save partial profile (just names) if other fields are missing
          await _sharedPrefs.saveUserName(
            firstName: updatedUser.firstName!,
            lastName: updatedUser.lastName!,
          );
        }
      }

      // Update local reactive state to trigger UI updates
      _user.value = updatedUser;
      update(); // Force refresh for widgets using GetBuilder
    } catch (e) {
      print("Error updating profile: $e");
      rethrow; // Re-throw to allow calling code to handle the error
    }
  }

  /// Save user names to Firestore immediately after signup
  /// This ensures basic user data is available in cloud storage
  Future<void> saveUserNamesAfterSignup(
      String firstName, String lastName) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) {
        print("No authenticated user found");
        return;
      }

      // Save basic info to Firestore (merge: true won't overwrite existing data)
      await _firestore.collection('users').doc(uid).set({
        'first_name': firstName,
        'last_name': lastName,
      }, SetOptions(merge: true));

      // Update local state with the new user data
      _user.value = AppUser(firstName: firstName, lastName: lastName);
    } catch (e) {
      print("Error saving user names to Firestore: $e");
      rethrow; // Re-throw to allow calling code to handle the error
    }
  }
}
