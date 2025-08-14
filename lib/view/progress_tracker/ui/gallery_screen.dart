import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/progress_photo_controller.dart';
import 'photo_view_screen.dart';

class GalleryScreen extends StatelessWidget {
  final int initialIndex;
  const GalleryScreen({super.key, this.initialIndex = 0});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ProgressPhotoController>();

    return Scaffold(
      appBar: AppBar(title: Text('${c.photos.length} Photos')),
      body: Obx(() {
        if (c.photos.isEmpty) {
          return const Center(child: Text('No photos yet'));
        }
        return Padding(
          padding: const EdgeInsets.all(12),
          child: GridView.builder(
            itemCount: c.photos.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (_, i) {
              final item = c.photos[i];
              return GestureDetector(
                onTap: () => Get.to(() => PhotoViewScreen(initialIndex: i)),
                child: Hero(
                  tag: 'photo_$i',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(File(item.path), fit: BoxFit.cover),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
