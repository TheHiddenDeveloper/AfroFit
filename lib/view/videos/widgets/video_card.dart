import 'package:fitnessapp/utils/app_colors.dart';
import 'package:flutter/material.dart';

class VideoCard extends StatelessWidget {
  final String title;
  final String thumbnail;
  final String channelTitle;
  final String duration;
  final String publishedAt;
  final VoidCallback onTap;

  const VideoCard({
    super.key,
    required this.title,
    required this.thumbnail,
    required this.channelTitle,
    required this.onTap,
    this.duration = '',
    this.publishedAt = '',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.grayColor.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thumbnail Container
                Container(
                  width: 120,
                  height: 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: AppColors.primaryG
                          .map((c) => c.withOpacity(0.1))
                          .toList(),
                    ),
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          thumbnail,
                          width: 120,
                          height: 90,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 120,
                              height: 90,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: AppColors.primaryG,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.play_circle_filled,
                                color: AppColors.whiteColor,
                                size: 40,
                              ),
                            );
                          },
                        ),
                      ),
                      // Play Button Overlay
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.blackColor.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.play_arrow,
                              color: AppColors.whiteColor,
                              size: 32,
                            ),
                          ),
                        ),
                      ),
                      // Duration Badge
                      if (duration.isNotEmpty)
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.blackColor.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              duration,
                              style: const TextStyle(
                                color: AppColors.whiteColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: AppColors.blackColor,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 8),

                      // Channel Info
                      Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: AppColors.secondaryG,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.fitness_center,
                              color: AppColors.whiteColor,
                              size: 14,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              channelTitle,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.grayColor,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      if (publishedAt.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          publishedAt,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.midGrayColor,
                          ),
                        ),
                      ],

                      const SizedBox(height: 8),

                      // Action Button
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: AppColors.primaryG,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          "WATCH NOW",
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
