// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_action_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserActionResponse _$UserActionResponseFromJson(Map<String, dynamic> json) =>
    UserActionResponse(
      json['isMatched'] as bool,
      json['isFreeRuntime'] as bool,
      (json['likeRemaining'] as num).toInt(),
    );

Map<String, dynamic> _$UserActionResponseToJson(UserActionResponse instance) =>
    <String, dynamic>{
      'isMatched': instance.isMatched,
      'isFreeRuntime': instance.isFreeRuntime,
      'likeRemaining': instance.likeRemaining,
    };
