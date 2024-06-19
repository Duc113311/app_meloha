// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prompt_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PromptDto _$PromptDtoFromJson(Map<String, dynamic> json) => PromptDto(
      codePrompt: json['codePrompt'] as String,
      answer: json['answer'] as String,
      id: json['id'] as String? ?? '',
      order: (json['order'] as num?)?.toInt(),
      insert: json['insert'] == null
          ? null
          : InsertDto.fromJson(json['insert'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PromptDtoToJson(PromptDto instance) => <String, dynamic>{
      'codePrompt': instance.codePrompt,
      'answer': instance.answer,
      'id': instance.id,
      'order': instance.order,
      'insert': instance.insert,
    };
