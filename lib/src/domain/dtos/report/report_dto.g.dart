// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReasonDto _$ReasonDtoFromJson(Map<String, dynamic> json) => ReasonDto(
      count: (json['count'] as num).toInt(),
      reports: (json['data'] as List<dynamic>)
          .map((e) => ReasonsDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ReasonDtoToJson(ReasonDto instance) => <String, dynamic>{
      'count': instance.count,
      'data': instance.reports,
    };

ReasonsDto _$ReasonsDtoFromJson(Map<String, dynamic> json) => ReasonsDto(
      id: json['_id'] as String,
      reason: json['reason'] as String,
      details:
          (json['details'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$ReasonsDtoToJson(ReasonsDto instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'reason': instance.reason,
      'details': instance.details,
    };

ReportDto _$ReportDtoFromJson(Map<String, dynamic> json) => ReportDto(
      userId: json['userId'] as String?,
      reasonId: json['reasonId'] as String?,
      reasonDetail: json['reasonDetail'] as String?,
      comments: json['comments'] as String?,
    );

Map<String, dynamic> _$ReportDtoToJson(ReportDto instance) => <String, dynamic>{
      'userId': instance.userId,
      'reasonId': instance.reasonId,
      'reasonDetail': instance.reasonDetail,
      'comments': instance.comments,
    };
