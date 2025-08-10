// lib/screens/finish_workout_screen.dart
import 'package:fitnessapp/common_widgets/round_gradient_button.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class FinishWorkoutScreen extends StatelessWidget {
  static String routeName = "/FinishWorkoutScreen";

  const FinishWorkoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),

              /// Completion image
              Image.asset(
                "assets/images/complete_workout.png",
                height: media.width * 0.8,
                fit: BoxFit.fitHeight,
              ),

              const SizedBox(height: 20),

              /// Title
              Text(
                "Congratulations! 🎉\nYou Have Finished Your Workout",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.blackColor,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 20),

              /// Quote
              Text(
                "Exercise is king and nutrition is queen. "
                "Combine the two and you will have a kingdom.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.grayColor,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "- Jack LaLanne",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.grayColor,
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                ),
              ),

              const Spacer(),

              /// Back to home button
              RoundGradientButton(
                title: "Back To Home",
                onPressed: () {
                  Get.toNamed("/DashboardScreen");
                },
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
