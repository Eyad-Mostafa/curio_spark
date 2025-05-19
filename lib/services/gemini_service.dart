import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:string_similarity/string_similarity.dart';
import 'package:curio_spark/services/notification_service.dart';

import '../model/curiosity.dart';

class CuriosityGeneratorService {
  static const String _apiKey = 'AIzaSyApIkQ3Ky3Noto2wYvD73Xe_9Hslqp9XM4';
  static const String _endpoint =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$_apiKey';

  static final List<String> _randomPrompts = [
    "Give me one surprising scientific fact that most people don't know.",
    "Share a lesser-known fact about space exploration.",
    "Tell me a weird historical event that sounds unbelievable.",
    "Provide one rare and fascinating animal behavior fact.",
    "What is a little-known fact about ancient civilizations?",
    "Share an interesting curiosity about human psychology.",
    "Give me one incredible fact about the oceans or sea creatures.",
    "Tell me something bizarre about the weather or climate.",
    "Share a strange technology invention from history.",
    "Give me one weird but true medical phenomenon.",
    "What is a surprising fact about plants and botany?",
    "Tell me an unusual fact related to sound, music, or vibration.",
    "Share a mystery or unsolved phenomenon that amazes scientists.",
    "Provide a rare fact about time, physics, or relativity.",
    "Share a cultural or religious tradition that is very unique.",
    "Give me a quirky fact about language or how alphabets evolved.",
    "Tell me one weird connection between math and the real world.",
    "Share one spooky or mysterious archaeological discovery.",
    "Tell me something amazing about light, optics, or colors.",
    "Give me an odd but real record from the Guinness World Records.",
    "Provide one fact about insects that sounds impossible.",
    "Share a legendary myth or folklore story from any culture.",
    "Tell me a fun, obscure fact about famous historical figures.",
    "What is one strange thing about how different animals sleep?",
    "Share a mind-blowing curiosity about the structure of the universe.",
    "Give me a rare fun fact about volcanoes, earthquakes, or geology.",
    "Tell me one interesting cultural fact about how people celebrate festivals.",
    "Share an unexpected historical invention and how it changed the world.",
    "Give me a fascinating curiosity about early computer history.",
    "Tell me something extraordinary about deserts or extreme environments.",
    "Provide an unusual fact about birds and their behaviors.",
    "Share a little-known fact about how memory works in the brain.",
    "Tell me a surprising fact related to ancient food or cooking techniques.",
    "Give me one unexpected fact about famous art or artists.",
    "Share an interesting curiosity about the Moon or Mars.",
    "Tell me one unbelievable but true fact about human survival stories.",
    "Provide one curiosity about colors and how animals see them differently.",
    "Share a weird but fascinating biological adaptation in nature.",
    "Tell me one little-known fact about famous battles or wars.",
    "Give me one strange curiosity about ice, snow, or glaciers.",
    "Share a short curiosity about time travel theories in science.",
    "Tell me a fun fact about the formation of Earth or other planets.",
    "Provide a quirky linguistic phenomenon across different languages.",
    "Share a surprising invention that came from an accident.",
    "Tell me one bizarre, real scientific experiment from history.",
    "Give me an unusual curiosity about trains, ships, or early transportation.",
    "Share a very rare fact about musical instruments or ancient music.",
    "Tell me one little-known story about space probes or satellites.",
    "Provide one unique curiosity about the history of mathematics.",
    "Share an interesting fact about the human brain and its functions.",
  ];

  static String _getRandomPrompt() {
    final random = Random();
    _randomPrompts.shuffle();
    return _randomPrompts[random.nextInt(_randomPrompts.length)];
  }

  static String _normalize(String s) =>
      s.toLowerCase().replaceAll(RegExp(r'[^\w\s]'), '').trim();

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
      }

      if (response.statusCode == 429) {
        print("⚠️ Gemini quota exceeded. Retrying after 1 hour...");
        await Future.delayed(const Duration(hours: 1));
        return null;
      }

      print("❌ Gemini error: ${response.statusCode}\n${response.body}");
      return null;
    } catch (e) {
      print("❌ Exception: $e");
      return null;
    }
  }

  static Future<bool> generateAndSaveUniqueCuriosity(
      Box<Curiosity> curiosityBox) async {
    while (true) {
      final prompt = _getRandomPrompt();
      final result = await _fetchFromGemini(prompt);
      if (result == null) continue;

      final trimmed = result.trim();
      final normalizedNew = _normalize(trimmed);

      const double simThreshold = 0.75;
      final isTooSimilar = curiosityBox.values.any((c) {
        final oldNorm = _normalize(c.content ?? '');
        final similarity =
            StringSimilarity.compareTwoStrings(normalizedNew, oldNorm);
        return similarity >= simThreshold;
      });

      if (isTooSimilar) {
        print(
            "⚠️ Fuzzy duplicate detected (≥ ${simThreshold * 100}%). Retrying...");
        continue;
      }

      final String id = DateTime.now().millisecondsSinceEpoch.toString();
      final curiosity = Curiosity(
        id: id,
        content: trimmed,
        isFavorite: false,
      );

      await curiosityBox.put(id, curiosity);
      print("✅ New curiosity saved: ${curiosity.content}");

      // Show notification for new curiosity
      await NotificationService.notifyNewCuriosity();
      return true;
    }
  }
}
