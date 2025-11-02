// src/providers/quiz_provider.dart
import 'dart:convert';
import 'package:SangKala/src/models/kuis.model.dart';
import 'package:SangKala/src/providers/progress_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../utils/storage_helper.dart';

class QuizProvider extends ChangeNotifier {
  Quiz? _quiz;
  Map<int, String> _answers = {}; // index question -> answer selected
  int? _score;

  Quiz? get quiz => _quiz;
  Map<int, String> get answers => _answers;
  int? get score => _score;
  String baseUrl = "https://besangkala-production.up.railway.app";

  Future<void> fetchQuiz(String materialId) async {
    try {
      final token = await StorageHelper.getToken();
      final res = await http.get(
        Uri.parse("$baseUrl/api/quiz/$materialId"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (res.statusCode == 200) {
        _quiz = Quiz.fromJson(jsonDecode(res.body));
        _answers.clear();
        _score = null;
        notifyListeners();
      } else {
        throw Exception("Failed to load quiz: ${res.statusCode}");
      }
    } catch (e) {
      debugPrint("fetchQuiz error: $e");
      rethrow;
    }
  }

  void selectAnswer(int questionIndex, String label) {
    _answers[questionIndex] = label;
    notifyListeners();
  }

  int calculateScore() {
    if (_quiz == null) return 0;
    int correct = 0;
    for (int i = 0; i < _quiz!.questions.length; i++) {
      final correctAnswer = _quiz!.questions[i].correctAnswer;
      if (_answers[i] == correctAnswer) correct++;
    }
    final score = (_quiz!.questions.isEmpty)
        ? 0
        : ((correct / _quiz!.questions.length) * 100).round();
    _score = score;
    return score;
  }

  /// Submit quiz → update progress sinkron dengan ProgressProvider
  // Future<void> submitQuiz({required String materialId}) async {
  //   if (_quiz == null) return;

  //   final token = await StorageHelper.getToken();

  //   // Format jawaban user
  //   final answersPayload = _answers.entries.map((entry) {
  //     final q = _quiz!.questions[entry.key];
  //     return {
  //       "questionId": q.id, // ambil dari model Question
  //       "selectedOption": entry.value,
  //     };
  //   }).toList();

  //   try {
  //     final res = await http.put(
  //       Uri.parse("$baseUrl/api/quiz/progress/$materialId/quiz"),
  //       headers: {
  //         "Authorization": "Bearer $token",
  //         "Content-Type": "application/json",
  //       },
  //       body: jsonEncode({"answers": answersPayload}),
  //     );

  //     if (res.statusCode == 200) {
  //       final data = jsonDecode(res.body);

  //       _score = data["score"];
  //       notifyListeners();
  //     } else {
  //       print("Submit failed: ${res.body}");
  //     }
  //   } catch (e) {
  //     print("Submit error: $e");
  //   }
  // }

  Future<int?> submitQuiz({required String materialId}) async {
    if (_quiz == null) return null;

    final token = await StorageHelper.getToken();

    final answersPayload = _answers.entries.map((entry) {
      final q = _quiz!.questions[entry.key];
      return {"questionId": q.id, "selectedOption": entry.value};
    }).toList();

    try {
      final res = await http.put(
        Uri.parse("$baseUrl/api/quiz/progress/$materialId/quiz"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"answers": answersPayload}),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        calculateScore();
        _score = data["score"];
        notifyListeners();
        return _score;
      } else {
        print("Submit failed: ${res.body}");
        return null;
      }
    } catch (e) {
      print("Submit error: $e");
      return null;
    }
  }

  // Future<void> submitQuiz(String materialId) async {
  //   if (_quiz == null) return;

  //   final token = await StorageHelper.getToken();
  //   final finalScore = calculateScore();

  //   try {
  //     final res = await http.put(
  //       Uri.parse("http://localhost:5000/api/progress/$materialId/quiz"),
  //       headers: {
  //         "Authorization": "Bearer $token",
  //         "Content-Type": "application/json",
  //       },
  //       body: jsonEncode({"score": finalScore, "quizTaken": true}),
  //     );

  //     if (res.statusCode == 200) {
  //       debugPrint("Progress updated successfully ✅");
  //     } else {
  //       debugPrint("Failed to update progress: ${res.statusCode}");
  //     }
  //   } catch (e) {
  //     debugPrint("submitQuiz error: $e");
  //   }
  // }
}
