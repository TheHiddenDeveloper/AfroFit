// lib/view/progress_tracker/ui/photo_view_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import '../controller/progress_photo_controller.dart';

class PhotoViewScreen extends StatefulWidget {
  final int initialIndex;
  const PhotoViewScreen({super.key, required this.initialIndex});

  @override
  State<PhotoViewScreen> createState() => _PhotoViewScreenState();
}

class _PhotoViewScreenState extends State<PhotoViewScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  final c = Get.find<ProgressPhotoController>();
  bool _showUI = true;
  int _currentIndex = 0;

  late AnimationController _uiAnimController;
  late Animation<double> _uiOpacity;
  late AnimationController _deleteAnimController;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);

    _uiAnimController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _deleteAnimController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _uiOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _uiAnimController, curve: Curves.easeInOut),
    );

    _uiAnimController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _uiAnimController.dispose();
    _deleteAnimController.dispose();
    super.dispose();
  }

  void _toggleUI() {
    setState(() => _showUI = !_showUI);
    if (_showUI) {
      _uiAnimController.forward();
    } else {
      _uiAnimController.reverse();
    }
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.whiteColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Delete Photo',
          style: TextStyle(
            color: AppColors.blackColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'Are you sure you want to delete this progress photo? This action cannot be undone.',
          style: TextStyle(
            color: AppColors.grayColor,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: AppColors.grayColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: AppColors.secondaryG,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
                _deleteCurrentPhoto();
              },
              child: Text(
                'Delete',
                style: TextStyle(
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteCurrentPhoto() async {
    final files = c.photos;
    if (_currentIndex < files.length) {
      await c.deletePhoto(files[_currentIndex].path);

      if (c.photos.isEmpty) {
        Navigator.pop(context);
      } else if (_currentIndex >= c.photos.length) {
        setState(() => _currentIndex = c.photos.length - 1);
        _pageController.animateToPage(
          _currentIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return "${months[date.month - 1]} ${date.day}, ${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      body: Obx(() {
        final files = c.photos;
        if (files.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.photo_outlined,
                  size: 64,
                  color: AppColors.grayColor,
                ),
                const SizedBox(height: 16),
                Text(
                  'No photos found',
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }

        return Stack(
          children: [
            // Photo viewer
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) => setState(() => _currentIndex = index),
              itemCount: files.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: _toggleUI,
                child: Hero(
                  tag: 'photo_$index',
                  child: InteractiveViewer(
                    minScale: 0.5,
                    maxScale: 3.0,
                    child: Center(
                      child: Image.file(
                        File(files[index].path),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Top UI
            AnimatedBuilder(
              animation: _uiOpacity,
              builder: (context, child) => Opacity(
                opacity: _uiOpacity.value,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.center,
                      colors: [
                        AppColors.blackColor.withOpacity(0.8),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.blackColor.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(
                                color: AppColors.whiteColor.withOpacity(0.3),
                              ),
                            ),
                            child: IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: AppColors.whiteColor,
                                size: 20,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.blackColor.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppColors.whiteColor.withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              '${_currentIndex + 1} of ${files.length}',
                              style: const TextStyle(
                                color: AppColors.whiteColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.secondaryColor1.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(
                                color: AppColors.secondaryColor1,
                              ),
                            ),
                            child: IconButton(
                              onPressed: _showDeleteDialog,
                              icon: const Icon(
                                Icons.delete_outline_rounded,
                                color: AppColors.whiteColor,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Bottom UI with photo info
            AnimatedBuilder(
              animation: _uiOpacity,
              builder: (context, child) => Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Opacity(
                  opacity: _uiOpacity.value,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.center,
                        colors: [
                          AppColors.blackColor.withOpacity(0.9),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: AppColors.blackColor.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppColors.whiteColor.withOpacity(0.1),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: AppColors.primaryG,
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: const Icon(
                                          Icons.camera_alt_outlined,
                                          color: AppColors.whiteColor,
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Progress Photo #${_currentIndex + 1}',
                                              style: const TextStyle(
                                                color: AppColors.whiteColor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              _formatDate(files[_currentIndex]
                                                      .takenAt ??
                                                  DateTime.now()),
                                              style: TextStyle(
                                                color: AppColors.whiteColor
                                                    .withOpacity(0.7),
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Page indicators
            if (files.length > 1)
              AnimatedBuilder(
                animation: _uiOpacity,
                builder: (context, child) => Positioned(
                  left: 0,
                  right: 0,
                  bottom: 140,
                  child: Opacity(
                    opacity: _uiOpacity.value,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        files.length,
                        (index) => Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: index == _currentIndex
                                ? AppColors.primaryColor1
                                : AppColors.whiteColor.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }
}
