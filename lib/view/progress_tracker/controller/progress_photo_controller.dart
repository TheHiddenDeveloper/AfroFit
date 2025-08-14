import 'package:get/get.dart';
import '../model/photo_entry.dart';
import '../services/progress_photo_service.dart';

class ProgressPhotoController extends GetxController {
  final ProgressPhotoService _service = ProgressPhotoService();

  final photos = <PhotoEntry>[].obs;
  final isLoading = false.obs;
  final daysSinceLast = RxnInt();

  @override
  void onInit() {
    super.onInit();
    refreshPhotos();
  }

  Future<void> refreshPhotos() async {
    isLoading.value = true;
    try {
      photos.value = await _service.listPhotos();
      daysSinceLast.value = await _service.daysSinceLast();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addPhotoFromTemp(String tempPath) async {
    await _service.saveCapturedFile(tempPath);
    await refreshPhotos();
  }

  Future<void> deletePhoto(String path) async {
    await _service.deletePhoto(path);
    await refreshPhotos();
  }
}
