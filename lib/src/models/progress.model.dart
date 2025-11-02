import 'package:json_annotation/json_annotation.dart';
import 'materi.model.dart';

part 'progress.model.g.dart';

@JsonSerializable(explicitToJson: true)
class Progress {
  @JsonKey(name: '_id')
  final String id;

  final String userId;

  @JsonKey(name: 'materialId')
  final Materi material;

  final bool done;
  final int currentIndex;
  final bool quizTaken;
  final int score;

  Progress({
    required this.id,
    required this.userId,
    required this.material,
    required this.done,
    required this.currentIndex,
    this.quizTaken = false,
    this.score = 0,
  });

  factory Progress.fromJson(Map<String, dynamic> json) =>
      _$ProgressFromJson(json);

  Map<String, dynamic> toJson() => _$ProgressToJson(this);
}
