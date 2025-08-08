import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  final String apiKey = dotenv.env['GEMINI_API_KEY'] ?? "";

  Stream<String> streamNutritionAdvice(String query) async* {
    final model = GenerativeModel(
      model: 'models/gemini-2.5-pro', // fast & cheap for streaming
      apiKey: apiKey,
    );

    final response = model.generateContentStream([Content.text(query)]);

    await for (final chunk in response) {
      if (chunk.text != null) {
        yield chunk.text!;
      }
    }
  }
}
