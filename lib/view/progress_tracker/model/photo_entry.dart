class PhotoEntry {
  final String path; // absolute file path
  final DateTime takenAt; // capture timestamp

  const PhotoEntry({
    required this.path,
    required this.takenAt,
  });

  factory PhotoEntry.fromFilename(String filePath) {
    // Expect file name like: photo_1715700000000.jpg
    final name = filePath.split('/').last;
    final millis = int.tryParse(
      name.replaceAll('photo_', '').replaceAll('.jpg', ''),
    );
    final dt = DateTime.fromMillisecondsSinceEpoch(
        millis ?? DateTime.now().millisecondsSinceEpoch);
    return PhotoEntry(path: filePath, takenAt: dt);
  }
}
