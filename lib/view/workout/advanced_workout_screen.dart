import 'package:fitnessapp/view/workout/data/workout_data.dart';
import 'package:fitnessapp/view/workout/models/workout_step.dart';
import 'package:fitnessapp/view/workout/workout_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdvancedWorkoutScreen extends StatelessWidget {
  const AdvancedWorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<WorkoutStep> steps = advancedWorkout;
    return Scaffold(
      appBar: AppBar(title: const Text("Advanced Workouts")),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Card(
            child: ListTile(
              title: const Text("Full Body Advanced Circuit"),
              subtitle:
                  const Text("23 minutes: 20 exercises + 3 rest sessions"),
              trailing: ElevatedButton(
                onPressed: () {
                  Get.to(() => WorkoutDetailsScreen(
                        title: "Full Body Advanced Circuit",
                        steps: steps,
                      ));
                },
                child: const Text("View"),
              ),
            ),
          ),
          // You can add more advanced workouts here
        ],
      ),
    );
  }
}
