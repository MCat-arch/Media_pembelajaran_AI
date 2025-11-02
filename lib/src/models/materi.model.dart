class Materi {
  final String id; // MongoDB ObjectId string (_id)
  final int? numericId; // id dari backend (Number, required)
  final String title; // 'materi' di backend
  final String img; // 'img' di backend
  final String? quizId; // ref ke quiz
  final String description; // optional
  final List<String> content; // array dari backend

  // UI-only fields
  double progress;
  bool isCompleted;

  Materi({
    required this.id,
    this.numericId,
    required this.title,
    required this.img,
    this.quizId,
    this.description = '',
    this.content = const [],
    this.progress = 0.0,
    this.isCompleted = false,
  });

  factory Materi.fromJson(Map<String, dynamic> json) {
    return Materi(
      id: (json['_id'] ?? '').toString(),
      numericId: (json['id'] is int)
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      title: (json['materi'] ?? '').toString(),
      img: (json['img'] ?? '').toString(),
      quizId: json['quizId']?.toString(),
      description: (json['description'] ?? '').toString(),
      content: (json['content'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'id': numericId,
    'materi': title,
    'img': img,
    'quizId': quizId,
    'description': description,
    'content': content,
  };
}
