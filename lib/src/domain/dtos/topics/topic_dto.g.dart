// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListTopicDto _$ListTopicDtoFromJson(Map<String, dynamic> json) => ListTopicDto(
      json['msgKey'] as String,
      json['message'] as String,
      (json['count'] as num).toInt(),
      (json['data'] as List<dynamic>)
          .map((e) => TopicDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ListTopicDtoToJson(ListTopicDto instance) =>
    <String, dynamic>{
      'msgKey': instance.msgKey,
      'message': instance.message,
      'count': instance.count,
      'data': instance.data,
    };

TopicDto _$TopicDtoFromJson(Map<String, dynamic> json) => TopicDto(
      json['_id'] as String,
      json['name'] as String,
      json['image'] as String,
      json['description'] as String,
      (json['typeExplore'] as num).toInt(),
    );

Map<String, dynamic> _$TopicDtoToJson(TopicDto instance) => <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'image': instance.image,
      'description': instance.description,
      'typeExplore': instance.typeExplore,
    };
