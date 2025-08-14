import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class CameraCaptureScreen extends StatefulWidget {
  const CameraCaptureScreen({super.key});

  @override
  State<CameraCaptureScreen> createState() => _CameraCaptureScreenState();
}

class _CameraCaptureScreenState extends State<CameraCaptureScreen>
    with TickerProviderStateMixin {
  CameraController? _controller;
  bool _isInitialized = false;
  bool _isCapturing = false;
  late AnimationController _anim;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _setup();
    _anim = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    _pulse = Tween(begin: 1.0, end: 0.85)
        .animate(CurvedAnimation(parent: _anim, curve: Curves.easeInOut));
  }

  Future<void> _setup() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      final cams = await availableCameras();
      if (cams.isEmpty) return;
      _controller = CameraController(cams.first, ResolutionPreset.high,
          enableAudio: false);
      await _controller!.initialize();
      if (mounted) setState(() => _isInitialized = true);
    } catch (_) {}
  }

  Future<void> _capture() async {
    if (!(_controller?.value.isInitialized ?? false) || _isCapturing) return;
    setState(() => _isCapturing = true);
    await _anim.forward();
    _anim.reverse();
    try {
      final tmpDir = await getTemporaryDirectory();
      final ts = DateTime.now().millisecondsSinceEpoch;
      final tempPath = p.join(tmpDir.path, 'capture_$ts.jpg');
      final x = await _controller!.takePicture();
      await x.saveTo(tempPath);
      if (!mounted) return;
      Navigator.pop(context, tempPath); // return temp path
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Capture failed: $e')),
      );
    } finally {
      if (mounted) setState(() => _isCapturing = false);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          CameraPreview(_controller!),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.25),
                  Colors.transparent,
                  Colors.black.withOpacity(0.5)
                ],
                stops: const [0, .6, 1],
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: Colors.white),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 36,
            child: SafeArea(
              child: AnimatedBuilder(
                animation: _pulse,
                builder: (_, __) => Transform.scale(
                  scale: _pulse.value,
                  child: GestureDetector(
                    onTap: _capture,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      height: 80,
                      width: 80,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white),
                      child: _isCapturing
                          ? const Center(
                              child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 3)))
                          : Container(
                              margin: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.black)),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
