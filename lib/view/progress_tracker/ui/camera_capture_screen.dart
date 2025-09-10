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
  String? _errorMessage;

  late AnimationController _captureAnim;
  late AnimationController _flashAnim;
  late AnimationController _uiAnim;

  late Animation<double> _captureScale;
  late Animation<double> _flashOpacity;
  late Animation<double> _uiFade;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _setup();
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

      if (_cameras.isEmpty) {
        setState(() => _errorMessage = 'No cameras available on this device');
        return;
      }

      await _initCamera();

      if (mounted) {
        setState(() {
          _isInitialized = true;
          _errorMessage = null;
        });
        _uiAnim.forward();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Camera initialization failed: ${e.toString()}';
        });
        _showErrorSnackBar(_errorMessage!);
      }
    }
  }

  Future<void> _initCamera() async {
    // Safely get camera index
    final cameraIndex = _isFrontCamera ? (_cameras.length > 1 ? 1 : 0) : 0;

    final camera = _cameras[cameraIndex];
    _controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _controller!.initialize();

    // Reset flash state when switching cameras
    _isFlashOn = false;
  }

  Future<void> _toggleCamera() async {
    if (_cameras.length < 2) return;

    setState(() {
      _isFrontCamera = !_isFrontCamera;
      _isInitialized = false;
    });

    try {
      await _controller?.dispose();
      await _initCamera();

      if (mounted) {
        setState(() => _isInitialized = true);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to switch camera: ${e.toString()}';
          _isInitialized = false;
        });
        _showErrorSnackBar(_errorMessage!);
      }
    }
  }

  Future<void> _toggleFlash() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    // Front camera typically doesn't support flash
    if (_isFrontCamera) {
      _showErrorSnackBar('Flash not available on front camera');
      return;
    }

    try {
      setState(() => _isFlashOn = !_isFlashOn);
      await _controller!.setFlashMode(
        _isFlashOn ? FlashMode.torch : FlashMode.off,
      );
    } catch (e) {
      // Revert flash state if setting failed
      setState(() => _isFlashOn = !_isFlashOn);
      _showErrorSnackBar('Flash control failed');
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
      _showErrorSnackBar('Capture failed: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isCapturing = false);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.secondaryColor1,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
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
    // Error state
    if (_errorMessage != null && !_isInitialized) {
      return Scaffold(
        backgroundColor: AppColors.blackColor,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: AppColors.secondaryColor1,
                  size: 60,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Camera Error',
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.whiteColor.withOpacity(0.8),
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor1,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Go Back',
                    style: TextStyle(color: AppColors.whiteColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Loading state
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
              const Text(
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
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: SafeArea(
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
                        child: const Text(
                          'Progress Photo',
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      // Flash toggle (only show for back camera)
                      _buildControlButton(
                        icon: _isFlashOn
                            ? Icons.flash_on_rounded
                            : Icons.flash_off_rounded,
                        onTap: _isFrontCamera ? null : _toggleFlash,
                        isActive: _isFlashOn,
                        isDisabled: _isFrontCamera,
                      ),
                    ],
                  ),
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
                        onTap: () => Navigator.pop(context),
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
                                  ? const Center(
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
    VoidCallback? onTap,
    bool isActive = false,
    bool isDisabled = false,
  }) {
    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: isDisabled
              ? AppColors.blackColor.withOpacity(0.3)
              : isActive
                  ? AppColors.primaryColor1.withOpacity(0.9)
                  : AppColors.blackColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isDisabled
                ? AppColors.grayColor.withOpacity(0.3)
                : isActive
                    ? AppColors.primaryColor1
                    : AppColors.whiteColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          color: isDisabled ? AppColors.grayColor : AppColors.whiteColor,
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
