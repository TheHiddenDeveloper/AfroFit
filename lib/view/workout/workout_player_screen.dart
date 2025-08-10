// lib/screens/workout/workout_player_screen.dart
import 'dart:async';
import 'package:fitnessapp/view/finish_workout/finish_workout_screen.dart';
import 'package:fitnessapp/view/workout/models/workout_step.dart';
import 'package:flutter/material.dart';

class WorkoutPlayerScreen extends StatefulWidget {
  final List<WorkoutStep> workoutSteps;
  const WorkoutPlayerScreen({super.key, required this.workoutSteps});

  @override
  State<WorkoutPlayerScreen> createState() => _WorkoutPlayerScreenState();
}

class _WorkoutPlayerScreenState extends State<WorkoutPlayerScreen> {
  int currentIndex = 0;
  int secondsLeft = 60; // each step is 60s
  Timer? timer;
  bool paused = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer?.cancel();
    setState(() {
      secondsLeft = 60;
      paused = false;
    });
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (paused) return;
      if (secondsLeft > 0) {
        setState(() => secondsLeft--);
      } else {
        nextStep();
      }
    });
  }

  void pauseOrResume() {
    setState(() {
      paused = !paused;
    });
  }

  void skipStep() {
    nextStep();
  }

  void nextStep() {
    if (currentIndex < widget.workoutSteps.length - 1) {
      setState(() {
        currentIndex++;
        secondsLeft = 60;
      });
    } else {
      timer?.cancel();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const FinishWorkoutScreen()),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final step = widget.workoutSteps[currentIndex];
    final isRest = step.isRest;
    final media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('${isRest ? "Rest" : step.name}'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 24),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                step.image,
                width: media.width,
                height: media.width * 0.6,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              isRest ? "Rest" : step.name,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              isRest ? "Recover for 1:00" : "Do this exercise for 1:00",
              style: const TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            CircleAvatar(
              radius: 56,
              child: Text(
                '${secondsLeft}s',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Step ${currentIndex + 1} of ${widget.workoutSteps.length}',
              style: const TextStyle(fontSize: 16),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: pauseOrResume,
                    child: Text(paused ? "Resume" : "Pause"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: skipStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black,
                    ),
                    child: const Text("Skip"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
