// Video Player Screen - Modernized
import 'package:fitnessapp/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoId;

  const VideoPlayerScreen({super.key, required this.videoId});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late YoutubePlayerController _controller;
  bool isFullScreen = false;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        enableCaption: true,
        captionLanguage: 'en',
      ),
    );

    _controller.addListener(() {
      if (mounted) {
        setState(() {
          isFullScreen = _controller.value.isFullScreen;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      onEnterFullScreen: () {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      },
      onExitFullScreen: () {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);
      },
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: AppColors.primaryColor1,
        progressColors: ProgressBarColors(
          playedColor: AppColors.primaryColor1,
          handleColor: AppColors.primaryColor1,
          bufferedColor: AppColors.primaryColor1.withOpacity(0.3),
          backgroundColor: AppColors.lightGrayColor,
        ),
        bottomActions: [
          CurrentPosition(),
          const SizedBox(width: 8),
          ProgressBar(
            isExpanded: true,
            colors: ProgressBarColors(
              playedColor: AppColors.primaryColor1,
              handleColor: AppColors.primaryColor1,
              bufferedColor: AppColors.primaryColor1.withOpacity(0.3),
              backgroundColor: AppColors.lightGrayColor,
            ),
          ),
          const SizedBox(width: 8),
          RemainingDuration(),
          FullScreenButton(),
        ],
      ),
      builder: (context, player) {
        return Scaffold(
          backgroundColor: AppColors.blackColor,
          appBar: isFullScreen
              ? null
              : AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: AppColors.blackColor,
                        size: 16,
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  title: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Video Player",
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  centerTitle: true,
                ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.blackColor,
                  AppColors.blackColor.withOpacity(0.8),
                ],
              ),
            ),
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: isFullScreen
                        ? BorderRadius.zero
                        : BorderRadius.circular(12),
                    boxShadow: isFullScreen
                        ? null
                        : [
                            BoxShadow(
                              color: AppColors.primaryColor1.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                  ),
                  child: ClipRRect(
                    borderRadius: isFullScreen
                        ? BorderRadius.zero
                        : BorderRadius.circular(12),
                    child: player,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
