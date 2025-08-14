import 'dart:io';
import 'package:fitnessapp/view/progress_tracker/controller/progress_photo_controller.dart';
import 'package:fitnessapp/view/progress_tracker/ui/camera_capture_screen.dart';
import 'package:fitnessapp/view/progress_tracker/ui/gallery_screen.dart';
import 'package:fitnessapp/view/progress_tracker/widgets/empty_state.dart';
import 'package:fitnessapp/view/progress_tracker/widgets/photo_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProgressPhotoScreen extends StatelessWidget {
  static const String routeName = "/ProgressPhotoScreen";
  const ProgressPhotoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ProgressPhotoController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Progress Photos"),
      ),
      body: Obx(() {
        if (c.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final count = c.photos.length;
        final d = c.daysSinceLast.value;
        final due = d == null || d >= 30;

        return RefreshIndicator(
          onRefresh: c.refreshPhotos,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Cadence card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: due
                      ? Colors.orange.withOpacity(0.15)
                      : Colors.green.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: (due ? Colors.orange : Colors.green)
                          .withOpacity(0.5)),
                ),
                child: Row(
                  children: [
                    Icon(due ? Icons.timer : Icons.check_circle,
                        color: due ? Colors.orange : Colors.green),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        d == null
                            ? "No photos yet — start your 30-day progress!"
                            : (due
                                ? "It's been $d day(s). You're due for a new photo."
                                : "Last photo was $d day(s) ago. Keep it up!"),
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ),
                    if (due)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text("Due",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Grid / Empty
              if (count == 0)
                const EmptyState()
              else
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: count,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (_, i) {
                    final item = c.photos[i];
                    return PhotoCard(
                      file: File(item.path),
                      date: item.takenAt,
                      onTap: () {
                        Get.to(() => GalleryScreen(initialIndex: i));
                      },
                      onDelete: () => c.deletePhoto(item.path),
                    );
                  },
                ),
              const SizedBox(height: 80),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final tempPath =
              await Get.to<String?>(() => const CameraCaptureScreen());
          if (tempPath != null) {
            await Get.find<ProgressPhotoController>()
                .addPhotoFromTemp(tempPath);
          }
        },
        icon: const Icon(Icons.photo_camera),
        label: const Text("Capture"),
      ),
    );
  }
}
