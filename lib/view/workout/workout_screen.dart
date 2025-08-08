import 'package:flutter/material.dart';
import 'beginner_workout_screen.dart';
import 'intermediate_workout_screen.dart';
import 'advanced_workout_screen.dart';

class WorkoutScreen extends StatelessWidget {
  static const routeName = '/workout';

  const WorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Workout Levels"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Beginner"),
              Tab(text: "Intermediate"),
              Tab(text: "Advanced"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            BeginnerWorkoutScreen(),
            IntermediateWorkoutScreen(),
            AdvancedWorkoutScreen(),
          ],
        ),
      ),
    );
  }
}
