// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  json['userId'] as String,
  json['username'] as String,
  json['email'] as String,
  json['password'] as String? ?? '',
  json['progress'] == null
      ? null
      : Progress.fromJson(json['progress'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'userId': instance.id,
  'username': instance.username,
  'email': instance.email,
  'password': instance.password,
  'progress': instance.progress?.toJson(),
};
