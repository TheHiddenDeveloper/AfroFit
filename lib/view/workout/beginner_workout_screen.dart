// lib/screens/workout/beginner_workout_screen.dart
import 'package:fitnessapp/utils/app_colors.dart';
import 'package:fitnessapp/view/workout/data/workout_data.dart';
import 'package:fitnessapp/view/workout/models/workout_step.dart';
import 'package:fitnessapp/view/workout/workout_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Beginner Workout Screen - Modernized
class BeginnerWorkoutScreen extends StatelessWidget {
  const BeginnerWorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<WorkoutStep> steps = beginnerWorkout;

    return Scaffold(
      backgroundColor: AppColors.lightGrayColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: AppColors.primaryG,
                  ),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.trending_up,
                        size: 60,
                        color: AppColors.whiteColor,
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Beginner Workouts",
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Perfect start to your fitness journey",
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildModernWorkoutCard(
                  context: context,
                  title: "Full Body Beginner Circuit",
                  duration: "11 minutes",
                  details: "10 exercises + 1 rest",
                  difficulty: "Beginner",
                  calories: "150-200",
                  icon: Icons.play_arrow,
                  gradient: AppColors.primaryG,
                  onTap: () {
                    Get.to(() => WorkoutDetailsScreen(
                          title: "Full Body Beginner Circuit",
                          steps: steps,
                        ));
                  },
                ),
                const SizedBox(height: 20),
                // Add more beginner workout cards here
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernWorkoutCard({
    required BuildContext context,
    required String title,
    required String duration,
    required String details,
    required String difficulty,
    required String calories,
    required IconData icon,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: gradient[0].withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: gradient,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          icon,
                          color: AppColors.whiteColor,
                          size: 28,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          difficulty,
                          style: const TextStyle(
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.whiteColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    details,
                    style: TextStyle(
                      color: AppColors.whiteColor.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      _buildInfoChip(Icons.schedule, duration),
                      const SizedBox(width: 12),
                      _buildInfoChip(
                          Icons.local_fire_department, "$calories cal"),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        "START WORKOUT",
                        style: TextStyle(
                          color: AppColors.blackColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.whiteColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: AppColors.whiteColor,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: AppColors.whiteColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
