// lib/models/workout_step.dart
class WorkoutStep {
  final String name;
  final bool isRest;
  final String image; // path to asset image (use a rest image for rest steps)

  const WorkoutStep({
    required this.name,
    this.isRest = false,
    required this.image,
  });
}
