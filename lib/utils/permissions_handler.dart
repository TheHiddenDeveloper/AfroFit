import 'package:permission_handler/permission_handler.dart';

class AppPermissions {
  // Request all necessary permissions
  static Future<void> requestAllPermissions() async {
    await [
      Permission.activityRecognition,
      Permission.locationWhenInUse,
      Permission.camera,
      Permission.photos, // For external storage access
      Permission.notification,
    ].request();
  }

  // Check if all permissions are granted
  static Future<bool> allPermissionsGranted() async {
    final statuses = await [
      Permission.activityRecognition,
      Permission.locationWhenInUse,
      Permission.camera,
      Permission.photos,
      Permission.notification,
    ].request();

    return statuses.values.every((status) => status.isGranted);
  }
}
