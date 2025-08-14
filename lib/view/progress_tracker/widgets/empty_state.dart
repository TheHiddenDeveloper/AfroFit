import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(Icons.photo_camera_outlined,
              size: 96, color: Colors.grey.withOpacity(.7)),
          const SizedBox(height: 12),
          Text("No progress photos yet",
              style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text("Capture your first photo to start your 30-day journey.",
              style: TextStyle(color: Colors.grey[500])),
        ],
      ),
    );
  }
}
