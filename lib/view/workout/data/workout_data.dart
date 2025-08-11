// lib/data/workout_data.dart
import 'package:fitnessapp/view/workout/models/workout_step.dart';

/// NOTE: each step is 1 minute (60 sec). Rest steps use the same 1 minute duration.
/// Make sure these asset paths exist in assets/images/ (list provided below).
final List<WorkoutStep> beginnerWorkout = [
  WorkoutStep(name: "Jumping Jacks", image: "assets/images/jumping_jacks.png"),
  WorkoutStep(name: "Leg Raises", image: "assets/images/leg_raises.jpeg"),
  WorkoutStep(name: "Push-ups", image: "assets/images/push_ups.jpeg"),
  WorkoutStep(name: "Abdominal Crunches", image: "assets/images/crunches.jpg"),
  WorkoutStep(name: "Burpees", image: "assets/images/burpees.jpeg"),
  WorkoutStep(
      name: "Rest",
      isRest: true,
      image: "assets/images/rest.jpeg"), // rest after 5
  WorkoutStep(name: "Squats", image: "assets/images/squats.jpeg"),
  WorkoutStep(
      name: "Tricep Dips on Chair", image: "assets/images/tricep_dips.jpeg"),
  WorkoutStep(name: "Plank", image: "assets/images/plank.jpeg"),
  WorkoutStep(
      name: "High Knees (in place)", image: "assets/images/high_knees.jpeg"),
  WorkoutStep(name: "Lunges", image: "assets/images/lunges.jpeg"),
];

final List<WorkoutStep> intermediateWorkout = [
  WorkoutStep(name: "Jumping Jacks", image: "assets/images/jumping_jacks.png"),
  WorkoutStep(name: "Leg Raises", image: "assets/images/leg_raises.jpeg"),
  WorkoutStep(name: "Push-ups", image: "assets/images/push_ups.jpeg"),
  WorkoutStep(name: "Abdominal Crunches", image: "assets/images/crunches.jpg"),
  WorkoutStep(
      name: "Russian Twists", image: "assets/images/russian_twists.jpeg"),
  WorkoutStep(
      name: "Rest",
      isRest: true,
      image: "assets/images/rest.jpeg"), // rest after 5
  WorkoutStep(name: "Squats", image: "assets/images/squats.jpeg"),
  WorkoutStep(
      name: "Tricep Dips on Chair", image: "assets/images/tricep_dips.jpeg"),
  WorkoutStep(name: "Plank", image: "assets/images/plank.jpeg"),
  WorkoutStep(
      name: "High Knees (in place)", image: "assets/images/high_knees.jpeg"),
  WorkoutStep(
      name: "Rest",
      isRest: true,
      image: "assets/images/rest.jpeg"), // rest after 10
  WorkoutStep(name: "Lunges", image: "assets/images/lunges.jpeg"),
  WorkoutStep(name: "T-Push Up", image: "assets/images/t_push_up.png"),
  WorkoutStep(name: "Side Plank (left)", image: "assets/images/side_plank.png"),
  WorkoutStep(
      name: "Side Plank (right)", image: "assets/images/side_plank.png"),
  WorkoutStep(
      name: "Mountain Climbers", image: "assets/images/mountain_climber.png"),
  WorkoutStep(name: "Burpees", image: "assets/images/burpees.jpeg"),
];

final List<WorkoutStep> advancedWorkout = [
  WorkoutStep(name: "Jumping Jacks", image: "assets/images/jumping_jacks.png"),
  WorkoutStep(name: "Glute Bridges", image: "assets/images/glute_bridges.png"),
  WorkoutStep(name: "Push-ups", image: "assets/images/push_ups.jpeg"),
  WorkoutStep(name: "Abdominal Crunches", image: "assets/images/crunches.jpg"),
  WorkoutStep(name: "Flutter Kicks", image: "assets/images/flutter_kicks.jpeg"),
  WorkoutStep(
      name: "Rest",
      isRest: true,
      image: "assets/images/rest.jpeg"), // rest after 5
  WorkoutStep(name: "Squats", image: "assets/images/squats.jpeg"),
  WorkoutStep(
      name: "Tricep Dips on Chair", image: "assets/images/tricep_dips.jpeg"),
  WorkoutStep(name: "Plank", image: "assets/images/plank.jpeg"),
  WorkoutStep(
      name: "High Knees (in place)", image: "assets/images/high_knees.jpeg"),
  WorkoutStep(
      name: "Rest",
      isRest: true,
      image: "assets/images/rest.jpeg"), // rest after 10
  WorkoutStep(name: "Lunges", image: "assets/images/lunges.jpeg"),
  WorkoutStep(
      name: "T-Push Up", image: "assets/images/t_push_up.png"), // change
  WorkoutStep(name: "Side Plank (left)", image: "assets/images/side_plank.png"),
  WorkoutStep(
      name: "Side Plank (right)", image: "assets/images/side_plank.png"),
  WorkoutStep(
      name: "Rest",
      isRest: true,
      image: "assets/images/rest.jpeg"), // rest after 15
  WorkoutStep(
      name: "Mountain Climbers", image: "assets/images/mountain_climber.png"),
  WorkoutStep(name: "Burpees", image: "assets/images/burpees.jpeg"),
  WorkoutStep(name: "Leg Raises", image: "assets/images/leg_raises.jpeg"),
  WorkoutStep(
      name: "Bicycle Crunches", image: "assets/images/bicycle_crunch.png"),
  WorkoutStep(name: "Donkey Kicks", image: "assets/images/donkey_kicks.jpeg"),
  WorkoutStep(
      name: "Russian Twists", image: "assets/images/russian_twists.jpeg"),
  WorkoutStep(name: "Superman", image: "assets/images/superman.jpeg"),
];
