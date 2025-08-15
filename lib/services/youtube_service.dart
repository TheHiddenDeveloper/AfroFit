import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class YoutubeService {
  final String apiKey = dotenv.env['YOUTUBE_API_KEY'] ?? '';
  final String channelId = "UCXIJgqnII2ZOINSWNOGFThA"; // Replace with your workout channel ID

  Future<List<Map<String, dynamic>>> fetchVideos() async {
    final url = Uri.parse(
      "https://www.googleapis.com/youtube/v3/search?part=snippet&channelId=$channelId&maxResults=10&order=date&type=video&key=$apiKey"
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Map<String, dynamic>> videos = [];
      for (var item in data['items']) {
        videos.add({
          'title': item['snippet']['title'],
          'thumbnail': item['snippet']['thumbnails']['high']['url'],
          'videoId': item['id']['videoId'],
        });
      }
      return videos;
    } else {
      throw Exception("Failed to load videos");
    }
  }
}
