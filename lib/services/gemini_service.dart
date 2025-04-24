import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import '../model/curiosity.dart';

class CuriosityGeneratorService {
  static const String _apiKey = 'AIzaSyAydsTTpYvXqydxr4Tq1jQaOlxVdJx86eM';
  static const String _endpoint =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-pro:generateContent?key=$_apiKey';

  static final List<String> _randomPrompts = [
    "Give me one amazing curiosity or lesser-known fact. Keep it short and interesting. No greetings or conclusions.",
    "Share one strange but true fact that surprises most people. Make it short and without any extras.",
    "Tell me one fascinating science or nature curiosity. No greetings or explanations, just the fact.",
    "Give me a rare and short amazing curiosity without any intro or outro.",
    "Send one weird but real piece of knowledge. Just the core fact, no surrounding text."
  ];

  static String _getRandomPrompt() {
    final random = Random();
    return _randomPrompts[random.nextInt(_randomPrompts.length)];
  }

  static Future<String?> _fetchFromGemini(String prompt) async {
    final body = {
      "contents": [
        {
          "parts": [
            {"text": prompt}
          ]
        }
      ]
    };

    try {
      final response = await http.post(
        Uri.parse(_endpoint),
        headers: {"Content-Type": "application/json"},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'];
      } else {
        print("Gemini error: ${response.statusCode}");
        print(response.body);
        return null;
      }
    } catch (e) {
      print("Exception: $e");
      return null;
    }
  }

  static Future<bool> generateAndSaveUniqueCuriosity() async {
    final box = Hive.box<Curiosity>('curiosities');

    while (true) {
      final prompt = _getRandomPrompt();
      final result = await _fetchFromGemini(prompt);
      if (result == null) {
        print("Failed to fetch curiosity. Trying again...");
        continue; // retry
      }

      final trimmed = result.trim();
      final alreadyExists = box.values.any((c) => c.content?.trim() == trimmed);

      if (alreadyExists) {
        print("Duplicate detected. Trying again...");
        continue; // keep trying
      }

      final String id = DateTime.now().millisecondsSinceEpoch.toString();
      final curiosity = Curiosity(
        id: id,
        content: trimmed,
        isFavorite: false,
      );

      await box.put(id, curiosity);
      print("New curiosity saved: ${curiosity.content}");
      return true;
    }
  }
}
