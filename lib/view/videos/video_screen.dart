// Video Screen - Modernized
import 'package:fitnessapp/view/videos/widgets/video_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/youtube_service.dart';
import 'video_player_screen.dart';

class AppColors {
  static const primaryColor1 = Color(0xFF92A3FD);
  static const primaryColor2 = Color(0xFF9DCEFF);
  static const secondaryColor1 = Color(0xFFC58BF2);
  static const secondaryColor2 = Color(0xFFEEA4CE);
  static const whiteColor = Color(0xFFFFFFFF);
  static const blackColor = Color(0xFF1D1617);
  static const grayColor = Color(0xFF7B6F72);
  static const lightGrayColor = Color(0xFFF7F8F8);
  static const midGrayColor = Color(0xFFADA4A5);
  static List<Color> get primaryG => [primaryColor1, primaryColor2];
  static List<Color> get secondaryG => [secondaryColor1, secondaryColor2];
}

class VideoScreen extends StatefulWidget {
  static String routeName = "/video";

  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen>
    with SingleTickerProviderStateMixin {
  final YoutubeService _youtubeService = YoutubeService();
  List<Map<String, dynamic>> videos = [];
  bool isLoading = true;
  String searchQuery = '';
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _loadVideos();
  }

  Future<void> _loadVideos() async {
    try {
      final data =
          await _youtubeService.fetchChannelVideos("UCJItL3dzLhLG1FGV1wZRS2w");
      setState(() {
        videos = data;
        isLoading = false;
      });
      _animationController.forward();
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint("Error fetching videos: $e");
    }
  }

  List<Map<String, dynamic>> get filteredVideos {
    if (searchQuery.isEmpty) return videos;
    return videos
        .where((video) =>
            video['title'].toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrayColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: AppColors.secondaryG,
                  ),
                ),
                child: const SafeArea(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.play_circle_filled,
                          size: 60,
                          color: AppColors.whiteColor,
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Workout Videos",
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Follow along with expert trainers",
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _SearchBarDelegate(),
          ),
          isLoading
              ? SliverFillRemaining(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.secondaryColor1.withOpacity(0.1),
                          AppColors.primaryColor1.withOpacity(0.1),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: AppColors.primaryG,
                              ),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: const Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.whiteColor),
                                strokeWidth: 3,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            "Loading workout videos...",
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.grayColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final video = filteredVideos[index];
                            return SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0, 0.5),
                                end: Offset.zero,
                              ).animate(CurvedAnimation(
                                parent: _animationController,
                                curve: Interval(
                                  index * 0.1,
                                  (index * 0.1) + 0.3,
                                  curve: Curves.easeOutCubic,
                                ),
                              )),
                              child: FadeTransition(
                                opacity: CurvedAnimation(
                                  parent: _animationController,
                                  curve: Interval(
                                    index * 0.1,
                                    (index * 0.1) + 0.3,
                                    curve: Curves.easeOut,
                                  ),
                                ),
                                child: VideoCard(
                                  title: video['title'] ?? '',
                                  thumbnail: video['thumbnail'] ?? '',
                                  channelTitle: video['channelTitle'] ?? '',
                                  duration: video['duration'] ?? '',
                                  publishedAt: video['publishedAt'] ?? '',
                                  onTap: () {
                                    Get.to(() => VideoPlayerScreen(
                                        videoId: video['videoId']));
                                  },
                                ),
                              ),
                            );
                          },
                          childCount: filteredVideos.length,
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}

class _SearchBarDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.lightGrayColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.grayColor.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: "Search workout videos...",
            hintStyle: TextStyle(
              color: AppColors.grayColor,
              fontSize: 14,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: AppColors.primaryColor1,
              size: 20,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: AppColors.whiteColor,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.blackColor,
          ),
          onChanged: (value) {
            // Handle search - you'll need to implement this in the parent widget
          },
        ),
      ),
    );
  }

  @override
  double get maxExtent => 80;

  @override
  double get minExtent => 80;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
