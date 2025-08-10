import 'package:fitnessapp/view/workout/data/workout_data.dart';
import 'package:fitnessapp/view/workout/models/workout_step.dart';
import 'package:fitnessapp/view/workout/workout_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IntermediateWorkoutScreen extends StatelessWidget {
  const IntermediateWorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<WorkoutStep> steps = intermediateWorkout;
    return Scaffold(
      appBar: AppBar(title: const Text("Intermediate Workouts")),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Card(
            child: ListTile(
              title: const Text("Full Body Intermediate Circuit"),
              subtitle:
                  const Text("17 minutes: 15 exercises + 2 rest sessions"),
              trailing: ElevatedButton(
                onPressed: () {
                  Get.to(() => WorkoutDetailsScreen(
                        title: "Full Body Intermediate Circuit",
                        steps: steps,
                      ));
                },
                child: const Text("View"),
              ),
            ),
          ),
          // You can add more intermediate workouts here
        ],
      ),
    );
  }
}
