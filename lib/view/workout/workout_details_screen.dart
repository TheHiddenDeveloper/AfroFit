// lib/screens/workout/workout_details_screen.dart
import 'package:fitnessapp/view/workout/models/workout_step.dart';
import 'package:fitnessapp/view/workout/workout_player_screen.dart';
import 'package:flutter/material.dart';

class WorkoutDetailsScreen extends StatelessWidget {
  final String title;
  final List<WorkoutStep> steps;

  const WorkoutDetailsScreen({
    super.key,
    required this.title,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: steps.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final s = steps[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          s.image,
                          width: 64,
                          height: 64,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(s.name),
                      subtitle:
                          Text(s.isRest ? "Rest — 1:00" : "Exercise — 1:00"),
                      trailing: Text("${index + 1}/${steps.length}"),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                child: const Text("Start Workout"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WorkoutPlayerScreen(workoutSteps: steps),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
