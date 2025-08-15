import 'package:flutter/material.dart';
import 'package:fitnessapp/services/youtube_service.dart';
import 'widgets/video_card.dart';

class VideosScreen extends StatefulWidget {
  static String routeName = "/videos";

  const VideosScreen({super.key});

  @override
  State<VideosScreen> createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> {
  final YoutubeService youtubeService = YoutubeService();
  late Future<List<Map<String, dynamic>>> videos;

  @override
  void initState() {
    super.initState();
    videos = youtubeService.fetchVideos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Workout Videos")),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: videos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No videos found"));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final video = snapshot.data![index];
              return VideoCard(
                title: video['title'],
                thumbnail: video['thumbnail'],
                videoId: video['videoId'],
              );
            },
          );
        },
      ),
    );
  }
}
