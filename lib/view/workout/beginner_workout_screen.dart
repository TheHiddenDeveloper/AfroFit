import 'package:flutter/material.dart';
import 'widgets/beginner_widget.dart';

class BeginnerWorkoutScreen extends StatelessWidget {
  const BeginnerWorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: BeginnerWidget(),
    );
  }
}
