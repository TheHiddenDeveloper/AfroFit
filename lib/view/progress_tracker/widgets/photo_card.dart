import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PhotoCard extends StatelessWidget {
  final File file;
  final DateTime date;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const PhotoCard({
    super.key,
    required this.file,
    required this.date,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final f = DateFormat.yMMMd().add_jm();
    return Stack(
      children: [
        GestureDetector(
          onTap: onTap,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.file(file,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity),
          ),
        ),
        Positioned(
          left: 8,
          bottom: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.55),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(f.format(date),
                style: const TextStyle(color: Colors.white, fontSize: 11)),
          ),
        ),
        Positioned(
          right: 6,
          top: 6,
          child: InkWell(
            onTap: onDelete,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.55),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(6),
              child: const Icon(Icons.delete, size: 18, color: Colors.white),
            ),
          ),
        )
      ],
    );
  }
}
