// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseDto _$BaseDtoFromJson(Map<String, dynamic> json) => BaseDto(
      json['message'] as String? ?? '',
      json['data'] as String? ?? '',
    );

Map<String, dynamic> _$BaseDtoToJson(BaseDto instance) => <String, dynamic>{
      'message': instance.message,
      'data': instance.data,
    };
