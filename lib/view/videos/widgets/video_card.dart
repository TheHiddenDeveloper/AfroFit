import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class VideoCard extends StatelessWidget {
  final String title;
  final String thumbnail;
  final String videoId;

  const VideoCard({
    super.key,
    required this.title,
    required this.thumbnail,
    required this.videoId,
  });

  void _launchVideo() async {
    final Uri url = Uri.parse("https://www.youtube.com/watch?v=$videoId");
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception("Could not launch video");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Image.network(thumbnail, width: 100, fit: BoxFit.cover),
        title: Text(title, maxLines: 2, overflow: TextOverflow.ellipsis),
        onTap: _launchVideo,
      ),
    );
  }
}
