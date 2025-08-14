import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../model/photo_entry.dart';

class ProgressPhotoService {
  static const String _folderName = 'progress_photos';

  Future<Directory> _photosDir() async {
    final dir = await getApplicationDocumentsDirectory();
    final photos = Directory(p.join(dir.path, _folderName));
    if (!await photos.exists()) {
      await photos.create(recursive: true);
    }
    return photos;
  }

  Future<List<PhotoEntry>> listPhotos() async {
    final dir = await _photosDir();
    final files = dir
        .listSync()
        .whereType<File>()
        .where((f) =>
            f.path.endsWith('.jpg') ||
            f.path.endsWith('.jpeg') ||
            f.path.endsWith('.png'))
        .toList();

    files.sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));

    return files.map((f) => PhotoEntry.fromFilename(f.path)).toList();
  }

  Future<String> saveCapturedFile(String tempFilePath) async {
    final dir = await _photosDir();
    final ts = DateTime.now().millisecondsSinceEpoch;
    final ext = p.extension(tempFilePath).isNotEmpty
        ? p.extension(tempFilePath)
        : '.jpg';
    final newPath = p.join(dir.path, 'photo_$ts$ext');

    final src = File(tempFilePath);
    await src.copy(newPath);
    return newPath;
  }

  Future<void> deletePhoto(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) await file.delete();
  }

  /// Days since the latest photo (returns null if no photos yet)
  Future<int?> daysSinceLast() async {
    final photos = await listPhotos();
    if (photos.isEmpty) return null;
    final last = photos.first.takenAt;
    return DateTime.now().difference(last).inDays;
  }
}
