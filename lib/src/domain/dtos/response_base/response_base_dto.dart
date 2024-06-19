import 'package:json_annotation/json_annotation.dart';
import 'dart:core';
part 'response_base_dto.g.dart';

@JsonSerializable(explicitToJson: true, genericArgumentFactories: true)
class ResultAPI<T> {
  @JsonKey(name: 'msgKey')
  String msgKey;

  @JsonKey(name: 'message')
  String message;

  @JsonKey(name:'data')
  T? data;

  ResultAPI({
    required this.msgKey,
    required this.message,
    this.data
  });

  factory ResultAPI.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT,) => _$ResultAPIFromJson(json, fromJsonT);
  Map<String, dynamic> toJson(Object Function(T value) toJsonT) => _$ResultAPIToJson(this, toJsonT);

}

@JsonSerializable()
class AnyJson {
  AnyJson();
}