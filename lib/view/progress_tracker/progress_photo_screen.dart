// lib/view/progress_tracker/ui/progress_photo_screen.dart
import 'dart:io';
import 'package:fitnessapp/view/progress_tracker/controller/progress_photo_controller.dart';
import 'package:fitnessapp/view/progress_tracker/ui/camera_capture_screen.dart';
import 'package:fitnessapp/view/progress_tracker/ui/gallery_screen.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// PhotoCard Widget
class PhotoCard extends StatelessWidget {
  final File file;
  final DateTime date;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const PhotoCard({
    super.key,
    required this.file,
    required this.date,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final f = DateFormat.yMMMd().add_jm();
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          GestureDetector(
            onTap: onTap,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.file(
                file,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
          Positioned(
            left: 8,
            bottom: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                f.format(date),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Positioned(
            right: 6,
            top: 6,
            child: GestureDetector(
              onTap: onDelete,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(6),
                child: const Icon(
                  Icons.delete_outline,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// EmptyState Widget
class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors:
                    AppColors.primaryG.map((c) => c.withOpacity(0.1)).toList(),
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.photo_camera_outlined,
              size: 64,
              color: AppColors.grayColor.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "No progress photos yet",
            style: TextStyle(
              color: AppColors.blackColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Capture your first photo to start your 30-day journey.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.grayColor,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

// Main ProgressPhotoScreen
class ProgressPhotoScreen extends StatefulWidget {
  static const String routeName = "/ProgressPhotoScreen";
  const ProgressPhotoScreen({super.key});

  @override
  State<ProgressPhotoScreen> createState() => _ProgressPhotoScreenState();
}

class _ProgressPhotoScreenState extends State<ProgressPhotoScreen> {
  late final ProgressPhotoController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ProgressPhotoController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrayColor,
      appBar: _buildAppBar(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildLoadingState();
        }

        return RefreshIndicator(
          onRefresh: controller.refreshPhotos,
          color: AppColors.primaryColor1,
          backgroundColor: AppColors.whiteColor,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProgressCard(),
                const SizedBox(height: 24),
                _buildPhotosSection(),
              ],
            ),
          ),
        );
      }),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.whiteColor,
      elevation: 0,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.lightGrayColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.blackColor,
            size: 16,
          ),
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: const Text(
        'Progress Photos',
        style: TextStyle(
          color: AppColors.blackColor,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.lightGrayColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.bar_chart_rounded,
              color: AppColors.grayColor,
              size: 20,
            ),
          ),
          onPressed: () {
            // Add stats functionality
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: AppColors.primaryG),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.photo_library_outlined,
              color: AppColors.whiteColor,
              size: 32,
            ),
          ),
          const SizedBox(height: 24),
          const CircularProgressIndicator(
            color: AppColors.primaryColor1,
            strokeWidth: 3,
          ),
          const SizedBox(height: 16),
          const Text(
            'Loading your progress...',
            style: TextStyle(
              color: AppColors.grayColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard() {
    final count = controller.photos.length;
    final daysSinceLast = controller.daysSinceLast.value;
    final isDue = daysSinceLast == null || daysSinceLast >= 30;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDue
              ? AppColors.secondaryG.map((c) => c.withOpacity(0.1)).toList()
              : AppColors.primaryG.map((c) => c.withOpacity(0.1)).toList(),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: (isDue ? AppColors.secondaryColor1 : AppColors.primaryColor1)
              .withOpacity(0.3),
        ),
        color: AppColors.whiteColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDue ? AppColors.secondaryG : AppColors.primaryG,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isDue ? Icons.schedule_rounded : Icons.trending_up_rounded,
                  color: AppColors.whiteColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isDue ? 'Photo Due!' : 'On Track!',
                      style: TextStyle(
                        color: isDue
                            ? AppColors.secondaryColor1
                            : AppColors.primaryColor1,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getProgressMessage(daysSinceLast, isDue),
                      style: const TextStyle(
                        color: AppColors.grayColor,
                        fontSize: 13,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (count > 0) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.lightGrayColor,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  _buildStatItem(
                      "Total Photos", "$count", Icons.photo_camera_outlined),
                  Container(
                    width: 1,
                    height: 30,
                    color: AppColors.lightGrayColor,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  _buildStatItem("Journey Days", "${count * 30}",
                      Icons.calendar_today_rounded),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Expanded(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.primaryColor1.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppColors.primaryColor1,
              size: 14,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.grayColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotosSection() {
    final count = controller.photos.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Your Progress',
              style: TextStyle(
                color: AppColors.blackColor,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (count > 0)
              GestureDetector(
                onTap: () => Get.to(() => const GalleryScreen(initialIndex: 0)),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor1.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'View All',
                        style: TextStyle(
                          color: AppColors.primaryColor1,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.primaryColor1,
                        size: 10,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        count == 0 ? const EmptyState() : _buildPhotoGrid(),
      ],
    );
  }

  Widget _buildPhotoGrid() {
    final photos = controller.photos;

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: photos.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) {
        final photo = photos[index];
        return PhotoCard(
          file: File(photo.path),
          date: photo.takenAt,
          onTap: () => Get.to(() => GalleryScreen(initialIndex: index)),
          onDelete: () => _showDeleteDialog(photo.path),
        );
      },
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () async {
        final tempPath =
            await Get.to<String?>(() => const CameraCaptureScreen());
        if (tempPath != null) {
          await controller.addPhotoFromTemp(tempPath);
        }
      },
      backgroundColor: AppColors.primaryColor1,
      foregroundColor: AppColors.whiteColor,
      elevation: 8,
      icon: const Icon(Icons.camera_alt_rounded),
      label: const Text(
        'Take Photo',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  void _showDeleteDialog(String photoPath) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.whiteColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delete Photo',
          style: TextStyle(
            color: AppColors.blackColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: const Text(
          'Are you sure you want to delete this progress photo? This action cannot be undone.',
          style: TextStyle(
            color: AppColors.grayColor,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: AppColors.grayColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              controller.deletePhoto(photoPath);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondaryColor1,
              foregroundColor: AppColors.whiteColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Delete',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  String _getProgressMessage(int? daysSinceLast, bool isDue) {
    if (daysSinceLast == null) {
      return "Start your 30-day progress journey";
    }
    if (isDue) {
      return "It's been $daysSinceLast day(s) since your last photo";
    }
    return "Last photo was $daysSinceLast day(s) ago";
  }
}
