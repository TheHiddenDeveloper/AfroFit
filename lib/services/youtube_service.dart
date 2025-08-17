import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class YouTubeVideo {
  final String videoId;
  final String title;
  final String thumbnailUrl;
  final String channelTitle;

  YouTubeVideo({
    required this.videoId,
    required this.title,
    required this.thumbnailUrl,
    required this.channelTitle,
  });

  factory YouTubeVideo.fromJson(Map<String, dynamic> json) {
    return YouTubeVideo(
      videoId: json['id']['videoId'],
      title: json['snippet']['title'],
      thumbnailUrl: json['snippet']['thumbnails']['high']['url'],
      channelTitle: json['snippet']['channelTitle'],
    );
  }
}

class YoutubeService {
  final String baseUrl = "https://www.googleapis.com/youtube/v3";

  Future<List<Map<String, dynamic>>> fetchChannelVideos(
      String channelId) async {
    final apiKey = dotenv.env['YOUTUBE_API_KEY'];
    final url =
        "$baseUrl/search?part=snippet&channelId=$channelId&maxResults=10&order=date&type=video&key=$apiKey";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final videos = data['items'] as List;
      return videos.map((video) {
        return {
          "videoId": video['id']['videoId'],
          "title": video['snippet']['title'],
          "thumbnail": video['snippet']['thumbnails']['high']['url'],
        };
      }).toList();
    } else {
      throw Exception("Failed to load YouTube videos");
    }
  }
}
