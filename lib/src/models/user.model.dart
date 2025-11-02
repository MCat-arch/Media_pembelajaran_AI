import 'package:SangKala/src/models/progress.model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.model.g.dart';
@JsonSerializable(explicitToJson: true)
class User {
  @JsonKey(name: "userId")
  String id;

  String username;
  String email;

  @JsonKey(defaultValue: "")
  String password; // default "" kalau tidak ada di JSON

  Progress? progress;

  User(this.id, this.username, this.email, this.password, this.progress);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
