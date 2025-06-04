import 'package:flutter/material.dart';
import 'package:fitnessapp/utils/app_colors.dart';

class PagerWidget extends StatelessWidget {
  final Map obj;
  const PagerWidget({Key? key, required this.obj}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ⬇️ Image goes here
          Image.asset(
            obj["image"],
            height: 250,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 40),

          // ⬇️ Title (centered)
          Text(
            obj["title"],
            textAlign: TextAlign.center, // ✅ Center text
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor1,
            ),
          ),
          const SizedBox(height: 20),

          // ⬇️ Subtitle (centered)
          Text(
            obj["subtitle"],
            textAlign: TextAlign.center, // ✅ Center text
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
