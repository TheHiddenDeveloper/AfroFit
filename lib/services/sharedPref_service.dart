// ignore: file_names
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitnessapp/utils/key_sharedPrefs.dart';

class SharedPrefsService {
  static final SharedPrefsService _instance = SharedPrefsService._internal();
  factory SharedPrefsService() => _instance;
  SharedPrefsService._internal();

  /// Onboarding
  Future<void> setOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(SharedPrefsKeys.hasCompletedOnboarding, true);
  }

  Future<bool> isOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(SharedPrefsKeys.hasCompletedOnboarding) ?? false;
  }

  /// Auth State
  Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(SharedPrefsKeys.isLoggedIn, value);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(SharedPrefsKeys.isLoggedIn) ?? false;
  }

  /// Save full user profile
  Future<void> saveUserProfile({
    required String firstName,
    required String lastName,
    required double height,
    required double weight,
    required int age,
    required String goal,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(SharedPrefsKeys.firstName, firstName);
    await prefs.setString(SharedPrefsKeys.lastName, lastName);
    await prefs.setDouble(SharedPrefsKeys.height, height);
    await prefs.setDouble(SharedPrefsKeys.weight, weight);
    await prefs.setInt(SharedPrefsKeys.age, age);
    await prefs.setString(SharedPrefsKeys.goal, goal);
  }

  Future<void> saveUserName({
  required String firstName,
  required String lastName,
}) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(SharedPrefsKeys.firstName, firstName);
  await prefs.setString(SharedPrefsKeys.lastName, lastName);
}


  /// Get profile fields (for offline access)
  Future<String?> getFirstName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(SharedPrefsKeys.firstName);
  }

  Future<String?> getLastName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(SharedPrefsKeys.lastName);
  }

  Future<double?> getHeight() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(SharedPrefsKeys.height);
  }

  Future<double?> getWeight() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(SharedPrefsKeys.weight);
  }

  Future<int?> getAge() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(SharedPrefsKeys.age);
  }

  Future<String?> getGoal() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(SharedPrefsKeys.goal);
  }

  /// Notification Toggle
  Future<void> saveNotificationPreference(bool isEnabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(SharedPrefsKeys.notificationEnabled, isEnabled);
  }

  Future<bool> getNotificationPreference() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(SharedPrefsKeys.notificationEnabled) ?? true;
  }

  /// Clear everything (logout)
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
