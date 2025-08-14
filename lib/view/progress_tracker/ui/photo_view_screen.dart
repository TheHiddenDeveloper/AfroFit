import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/progress_photo_controller.dart';

class PhotoViewScreen extends StatefulWidget {
  final int initialIndex;
  const PhotoViewScreen({super.key, required this.initialIndex});

  @override
  State<PhotoViewScreen> createState() => _PhotoViewScreenState();
}

class _PhotoViewScreenState extends State<PhotoViewScreen> {
  late PageController _page;
  final c = Get.find<ProgressPhotoController>();
  bool _showUI = true;
  int _current = 0;

  @override
  void initState() {
    super.initState();
    _current = widget.initialIndex;
    _page = PageController(initialPage: _current);
  }

  @override
  void dispose() {
    _page.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        final files = c.photos;
        return Stack(
          children: [
            PageView.builder(
              controller: _page,
              onPageChanged: (i) => setState(() => _current = i),
              itemCount: files.length,
              itemBuilder: (_, i) => GestureDetector(
                onTap: () => setState(() => _showUI = !_showUI),
                child: Hero(
                  tag: 'photo_$i',
                  child: InteractiveViewer(
                    child: Center(
                      child:
                          Image.file(File(files[i].path), fit: BoxFit.contain),
                    ),
                  ),
                ),
              ),
            ),
            // Top bar
            AnimatedOpacity(
              opacity: _showUI ? 1 : 0,
              duration: const Duration(milliseconds: 200),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios_new,
                            color: Colors.white),
                      ),
                      const Spacer(),
                      Text('${_current + 1}/${files.length}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600)),
                      const Spacer(),
                      IconButton(
                        onPressed: () => c.deletePhoto(files[_current].path),
                        icon: const Icon(Icons.delete, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        );
      }),
    );
  }
}
