// ignore: file_names
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitnessapp/utils/key_sharedPrefs.dart';

class SharedPrefsService {
  static final SharedPrefsService _instance = SharedPrefsService._internal();
  factory SharedPrefsService() => _instance;
  SharedPrefsService._internal();

  Future<void> setOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(SharedPrefsKeys.hasCompletedOnboarding, true);
  }

  Future<bool> isOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(SharedPrefsKeys.hasCompletedOnboarding) ?? false;
  }

  // 🔐 Save user login state
  Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(SharedPrefsKeys.isLoggedIn, value);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(SharedPrefsKeys.isLoggedIn) ?? false;
  }

  // 🙋‍♂️ Save and get first name
  Future<void> saveUserName({required firstName,required String lastName}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(SharedPrefsKeys.firstName, firstName);
    await prefs.setString(SharedPrefsKeys.lastName, lastName);
  }

  Future<String?> getFirstName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(SharedPrefsKeys.firstName);
  }

  Future<String?> getLastName() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(SharedPrefsKeys.lastName);
}

  // 🔓 Clear all data (e.g. on logout)
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
