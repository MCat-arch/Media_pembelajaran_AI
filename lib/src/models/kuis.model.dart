// src/models/quiz.dart
class Option {
  final String label; // A, B, C, D
  final String text;

  Option({required this.label, required this.text});

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(label: json['label'], text: json['text']);
  }
}

class Question {
  final String id;
  final String questionText;
  final List<Option> options;
  final String correctAnswer;

  Question({
    required this.id,
    required this.questionText,
    required this.options,
    required this.correctAnswer,
  });

  factory Question.fromJson(Map<String, dynamic> json) {

    String parseId(dynamic val) {
      if (val == null) return '';
      if (val is String) return val;
      if (val is Map && val.containsKey('\$oid')) return val['\$oid'];
      return val.toString();
    }

    return Question(
      id: parseId(json['_id']),
      questionText: json['questionText'],
      options: (json['options'] as List)
          .map((o) => Option.fromJson(o))
          .toList(),
      correctAnswer: json['correctAnswer'],
    );
  }
}

class Quiz {
  final String id;
  final String materialId;
  final List<Question> questions;

  Quiz({required this.id, required this.materialId, required this.questions});

  factory Quiz.fromJson(Map<String, dynamic> json) {
    String parseId(dynamic val) {
      if (val == null) return '';
      if (val is String) return val;
      if (val is Map && val.containsKey('\$oid')) return val['\$oid'];
      return val.toString();
    }

    return Quiz(
      id: parseId(json['_id']),
      materialId: parseId(json['materialId']),
      questions: (json['questions'] as List)
          .map((q) => Question.fromJson(q))
          .toList(),
    );
  }
}
