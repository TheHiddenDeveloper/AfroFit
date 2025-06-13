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
}
