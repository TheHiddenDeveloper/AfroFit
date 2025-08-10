import 'package:flutter/material.dart';

class ProgressTrackerWidget extends StatelessWidget {
  final int completed;
  final int goal;

  const ProgressTrackerWidget({
    super.key,
    required this.completed,
    required this.goal,
  });

  @override
  Widget build(BuildContext context) {
    double progress = goal > 0 ? completed / goal : 0.0;
    progress = progress.clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Progress this week: $completed / $goal workouts",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation(
                Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text("${(progress * 100).toStringAsFixed(0)}% completed"),
        ],
      ),
    );
  }
}
