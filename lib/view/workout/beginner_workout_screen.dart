// lib/screens/workout/beginner_workout_screen.dart
import 'package:fitnessapp/view/workout/data/workout_data.dart';
import 'package:fitnessapp/view/workout/models/workout_step.dart';
import 'package:fitnessapp/view/workout/workout_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BeginnerWorkoutScreen extends StatelessWidget {
  const BeginnerWorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<WorkoutStep> steps = beginnerWorkout;
    return Scaffold(
      appBar: AppBar(title: const Text("Beginner Workouts")),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Card(
            child: ListTile(
              title: const Text("Full Body Beginner Circuit"),
              subtitle: const Text("11 minutes: 10 exercises + 1 rest"),
              trailing: ElevatedButton(
                onPressed: () {
                  Get.to(() => WorkoutDetailsScreen(
                        title: "Full Body Beginner Circuit",
                        steps: steps,
                      ));
                },
                child: const Text("View"),
              ),
            ),
          ),
          // Add more cards if you want different named workouts that use subsets of steps.
        ],
      ),
    );
  }
}
