// lib/screens/camera_capture_screen.dart
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:fitnessapp/utils/app_colors.dart';

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
  bool _isFlashOn = false;
  bool _isFrontCamera = false;
  List<CameraDescription> _cameras = [];

  late AnimationController _captureAnim;
  late AnimationController _flashAnim;
  late AnimationController _uiAnim;

  late Animation<double> _captureScale;
  late Animation<double> _flashOpacity;
  late Animation<double> _uiFade;

  @override
  void initState() {
    super.initState();
    _setup();
    _initAnimations();
  }

  void _initAnimations() {
    _captureAnim = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _flashAnim = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _uiAnim = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _captureScale = Tween(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _captureAnim, curve: Curves.easeInOut),
    );

    _flashOpacity = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _flashAnim, curve: Curves.easeInOut),
    );

    _uiFade = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _uiAnim, curve: Curves.easeOutCubic),
    );
  }

  Future<void> _setup() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      _cameras = await availableCameras();
      if (_cameras.isEmpty) return;

      await _initCamera();
      if (mounted) {
        setState(() => _isInitialized = true);
        _uiAnim.forward();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Camera initialization failed: $e'),
            backgroundColor: AppColors.secondaryColor1,
          ),
        );
      }
    }
  }

  Future<void> _initCamera() async {
    final camera = _cameras[_isFrontCamera ? 1 : 0];
    _controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );
    await _controller!.initialize();
  }

  Future<void> _toggleCamera() async {
    if (_cameras.length < 2) return;

    setState(() {
      _isFrontCamera = !_isFrontCamera;
      _isInitialized = false;
    });

    await _controller?.dispose();
    await _initCamera();

    if (mounted) {
      setState(() => _isInitialized = true);
    }
  }

  Future<void> _toggleFlash() async {
    if (_controller == null) return;

    setState(() => _isFlashOn = !_isFlashOn);

    try {
      await _controller!.setFlashMode(
        _isFlashOn ? FlashMode.torch : FlashMode.off,
      );
    } catch (e) {
      // Handle flash error
    }
  }

  Future<void> _capture() async {
    if (!(_controller?.value.isInitialized ?? false) || _isCapturing) return;

    setState(() => _isCapturing = true);

    // Trigger animations
    _captureAnim.forward().then((_) => _captureAnim.reverse());
    _flashAnim.forward().then((_) => _flashAnim.reverse());

    try {
      final tmpDir = await getTemporaryDirectory();
      final ts = DateTime.now().millisecondsSinceEpoch;
      final tempPath = p.join(tmpDir.path, 'capture_$ts.jpg');
      final image = await _controller!.takePicture();
      await image.saveTo(tempPath);

      if (!mounted) return;
      Navigator.pop(context, tempPath);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Capture failed: $e'),
          backgroundColor: AppColors.secondaryColor1,
        ),
      );
    } finally {
      if (mounted) setState(() => _isCapturing = false);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _captureAnim.dispose();
    _flashAnim.dispose();
    _uiAnim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Scaffold(
        backgroundColor: AppColors.blackColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: AppColors.primaryG,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_alt_outlined,
                  color: AppColors.whiteColor,
                  size: 40,
                ),
              ),
              const SizedBox(height: 24),
              const CircularProgressIndicator(
                color: AppColors.primaryColor1,
                strokeWidth: 3,
              ),
              const SizedBox(height: 16),
              Text(
                'Initializing camera...',
                style: TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.blackColor,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Camera preview
          CameraPreview(_controller!),

          // Flash overlay
          AnimatedBuilder(
            animation: _flashOpacity,
            builder: (context, child) => Container(
              color:
                  AppColors.whiteColor.withOpacity(_flashOpacity.value * 0.8),
            ),
          ),

          // Gradient overlays for better UI visibility
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.blackColor.withOpacity(0.6),
                  Colors.transparent,
                  Colors.transparent,
                  AppColors.blackColor.withOpacity(0.8),
                ],
                stops: const [0.0, 0.2, 0.7, 1.0],
              ),
            ),
          ),

          // Top UI controls
          SafeArea(
            child: FadeTransition(
              opacity: _uiFade,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Close button
                    _buildControlButton(
                      icon: Icons.close_rounded,
                      onTap: () => Navigator.pop(context),
                    ),

                    // Camera title
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.blackColor.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.primaryColor1.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'Progress Photo',
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    // Flash toggle
                    _buildControlButton(
                      icon: _isFlashOn
                          ? Icons.flash_on_rounded
                          : Icons.flash_off_rounded,
                      onTap: _toggleFlash,
                      isActive: _isFlashOn,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom controls
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              child: FadeTransition(
                opacity: _uiFade,
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Gallery shortcut (placeholder)
                      _buildSecondaryButton(
                        icon: Icons.photo_library_outlined,
                        onTap: () {}, // Add gallery navigation
                      ),

                      // Capture button
                      AnimatedBuilder(
                        animation: _captureScale,
                        builder: (context, child) => Transform.scale(
                          scale: _captureScale.value,
                          child: GestureDetector(
                            onTap: _capture,
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.whiteColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primaryColor1
                                        .withOpacity(0.4),
                                    blurRadius: 20,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: _isCapturing
                                  ? Center(
                                      child: SizedBox(
                                        width: 32,
                                        height: 32,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 3,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            AppColors.primaryColor1,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      margin: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          colors: AppColors.primaryG,
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),

                      // Camera switch
                      _buildSecondaryButton(
                        icon: Icons.flip_camera_ios_outlined,
                        onTap: _cameras.length > 1 ? _toggleCamera : null,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primaryColor1.withOpacity(0.9)
              : AppColors.blackColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isActive
                ? AppColors.primaryColor1
                : AppColors.whiteColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          color: AppColors.whiteColor,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildSecondaryButton({
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.blackColor.withOpacity(0.6),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: AppColors.whiteColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          color: onTap != null ? AppColors.whiteColor : AppColors.midGrayColor,
          size: 28,
        ),
      ),
    );
  }
}
