import 'package:fitnessapp/view/nutrition/widgets/gemini_chat_widget.dart';
import 'package:flutter/material.dart';

class NutritionScreen extends StatelessWidget {
  const NutritionScreen({super.key});

  static const String routeName = "/NutritionScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Nutrition Assistant"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GeminiChatWidget(),
      ),
    );
  }
}
