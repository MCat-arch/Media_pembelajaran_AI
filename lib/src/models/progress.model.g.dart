// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Progress _$ProgressFromJson(Map<String, dynamic> json) => Progress(
  id: json['_id'] as String,
  userId: json['userId'] as String,
  material: Materi.fromJson(json['materialId'] as Map<String, dynamic>),
  done: json['done'] as bool? ?? false,
  currentIndex: (json['currentIndex'] as num?)?.toInt() ?? 0,
  quizTaken: json['quizTaken'] as bool? ?? false,
  score: (json['score'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$ProgressToJson(Progress instance) => <String, dynamic>{
  '_id': instance.id,
  'userId': instance.userId,
  'materialId': instance.material.id,
  'done': instance.done,
  'currentIndex': instance.currentIndex,
  'quizTaken': instance.quizTaken,
  'score': instance.score,
};
