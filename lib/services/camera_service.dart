import 'package:camera/camera.dart';

class CameraService {
  static CameraController? _cameraController;

  static Future<void> initCamera() async {
    final cameras = await availableCameras();
    _cameraController = CameraController(
      cameras.first,
      ResolutionPreset.high,
      enableAudio: false,
    );
    await _cameraController!.initialize();
  }

  static CameraController? get controller => _cameraController;

  static void disposeCamera() {
    _cameraController?.dispose();
  }
}
