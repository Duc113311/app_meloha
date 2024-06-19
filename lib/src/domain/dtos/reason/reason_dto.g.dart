// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reason_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReasonResponseDto _$ReasonResponseDtoFromJson(Map<String, dynamic> json) =>
    ReasonResponseDto(
      reasons: (json['reason'] as List<dynamic>)
          .map((e) => ReasonDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ReasonResponseDtoToJson(ReasonResponseDto instance) =>
    <String, dynamic>{
      'reason': instance.reasons,
    };

ReasonDto _$ReasonDtoFromJson(Map<String, dynamic> json) => ReasonDto(
      code: json['code'] as String? ?? '',
      value: json['value'] as String? ?? '',
      codeReasons: (json['codeReason'] as List<dynamic>)
          .map((e) => CodeReason.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ReasonDtoToJson(ReasonDto instance) => <String, dynamic>{
      'code': instance.code,
      'value': instance.value,
      'codeReason': instance.codeReasons,
    };

CodeReason _$CodeReasonFromJson(Map<String, dynamic> json) => CodeReason(
      json['codeTitle'] as String,
      json['value'] as String,
      (json['codeReasonDetail'] as List<dynamic>)
          .map((e) => CodeReasonDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CodeReasonToJson(CodeReason instance) =>
    <String, dynamic>{
      'codeTitle': instance.codeTitle,
      'value': instance.value,
      'codeReasonDetail': instance.codeReasonDetails,
    };

CodeReasonDetail _$CodeReasonDetailFromJson(Map<String, dynamic> json) =>
    CodeReasonDetail(
      codeDetail: json['codeDetail'] as String? ?? '',
      value: json['value'] as String? ?? '',
    );

Map<String, dynamic> _$CodeReasonDetailToJson(CodeReasonDetail instance) =>
    <String, dynamic>{
      'codeDetail': instance.codeDetail,
      'value': instance.value,
    };
