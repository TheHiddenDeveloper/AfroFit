// lib/data/workout_data.dart
import 'package:fitnessapp/view/workout/models/workout_step.dart';

/// NOTE: each step is 1 minute (60 sec). Rest steps use the same 1 minute duration.
/// Make sure these asset paths exist in assets/images/ (list provided below).
final List<WorkoutStep> beginnerWorkout = [
  const WorkoutStep(
      name: "Jumping Jacks", image: "assets/images/jumping_jacks.png"),
  const WorkoutStep(name: "Leg Raises", image: "assets/images/leg_raises.jpeg"),
  const WorkoutStep(name: "Push-ups", image: "assets/images/push_ups.jpeg"),
  const WorkoutStep(
      name: "Abdominal Crunches", image: "assets/images/crunches.jpg"),
  const WorkoutStep(name: "Burpees", image: "assets/images/burpees.jpeg"),
  const WorkoutStep(
      name: "Rest",
      isRest: true,
      image: "assets/images/rest.jpeg"), // rest after 5
  const WorkoutStep(name: "Squats", image: "assets/images/squats.jpeg"),
  const WorkoutStep(
      name: "Tricep Dips on Chair", image: "assets/images/tricep_dips.jpeg"),
  const WorkoutStep(name: "Plank", image: "assets/images/plank.jpeg"),
  const WorkoutStep(
      name: "High Knees (in place)", image: "assets/images/high_knees.jpeg"),
  const WorkoutStep(name: "Lunges", image: "assets/images/lunges.jpeg"),
];

final List<WorkoutStep> intermediateWorkout = [
  const WorkoutStep(
      name: "Jumping Jacks", image: "assets/images/jumping_jacks.png"),
  const WorkoutStep(name: "Leg Raises", image: "assets/images/leg_raises.jpeg"),
  const WorkoutStep(name: "Push-ups", image: "assets/images/push_ups.jpeg"),
  const WorkoutStep(
      name: "Abdominal Crunches", image: "assets/images/crunches.jpg"),
  const WorkoutStep(
      name: "Russian Twists", image: "assets/images/russian_twists.jpeg"),
  const WorkoutStep(
      name: "Rest",
      isRest: true,
      image: "assets/images/rest.jpeg"), // rest after 5
  const WorkoutStep(name: "Squats", image: "assets/images/squats.jpeg"),
  const WorkoutStep(
      name: "Tricep Dips on Chair", image: "assets/images/tricep_dips.jpeg"),
  const WorkoutStep(name: "Plank", image: "assets/images/plank.jpeg"),
  const WorkoutStep(
      name: "High Knees (in place)", image: "assets/images/high_knees.jpeg"),
  const WorkoutStep(
      name: "Rest",
      isRest: true,
      image: "assets/images/rest.jpeg"), // rest after 10
  const WorkoutStep(name: "Lunges", image: "assets/images/lunges.jpeg"),
  const WorkoutStep(name: "T-Push Up", image: "assets/images/t_push_up.png"),
  const WorkoutStep(
      name: "Side Plank (left)", image: "assets/images/side_plank.png"),
  const WorkoutStep(
      name: "Side Plank (right)", image: "assets/images/side_plank.png"),
  const WorkoutStep(
      name: "Mountain Climbers", image: "assets/images/mountain_climber.png"),
  const WorkoutStep(name: "Burpees", image: "assets/images/burpees.jpeg"),
];

final List<WorkoutStep> advancedWorkout = [
  const WorkoutStep(
      name: "Jumping Jacks", image: "assets/images/jumping_jacks.png"),
  const WorkoutStep(
      name: "Glute Bridges", image: "assets/images/glute_bridges.png"),
  const WorkoutStep(name: "Push-ups", image: "assets/images/push_ups.jpeg"),
  const WorkoutStep(
      name: "Abdominal Crunches", image: "assets/images/crunches.jpg"),
  const WorkoutStep(
      name: "Flutter Kicks", image: "assets/images/flutter_kicks.jpeg"),
  const WorkoutStep(
      name: "Rest",
      isRest: true,
      image: "assets/images/rest.jpeg"), // rest after 5
  const WorkoutStep(name: "Squats", image: "assets/images/squats.jpeg"),
  const WorkoutStep(
      name: "Tricep Dips on Chair", image: "assets/images/tricep_dips.jpeg"),
  const WorkoutStep(name: "Plank", image: "assets/images/plank.jpeg"),
  const WorkoutStep(
      name: "High Knees (in place)", image: "assets/images/high_knees.jpeg"),
  const WorkoutStep(
      name: "Rest",
      isRest: true,
      image: "assets/images/rest.jpeg"), // rest after 10
  const WorkoutStep(name: "Lunges", image: "assets/images/lunges.jpeg"),
  const WorkoutStep(
      name: "T-Push Up", image: "assets/images/t_push_up.png"), // change
  const WorkoutStep(
      name: "Side Plank (left)", image: "assets/images/side_plank.png"),
  const WorkoutStep(
      name: "Side Plank (right)", image: "assets/images/side_plank.png"),
  const WorkoutStep(
      name: "Rest",
      isRest: true,
      image: "assets/images/rest.jpeg"), // rest after 15
  const WorkoutStep(
      name: "Mountain Climbers", image: "assets/images/mountain_climber.png"),
  const WorkoutStep(name: "Burpees", image: "assets/images/burpees.jpeg"),
  const WorkoutStep(name: "Leg Raises", image: "assets/images/leg_raises.jpeg"),
  const WorkoutStep(
      name: "Bicycle Crunches", image: "assets/images/bicycle_crunch.png"),
  const WorkoutStep(
      name: "Donkey Kicks", image: "assets/images/donkey_kicks.jpeg"),
  const WorkoutStep(
      name: "Russian Twists", image: "assets/images/russian_twists.jpeg"),
  const WorkoutStep(name: "Superman", image: "assets/images/superman.jpeg"),
];
