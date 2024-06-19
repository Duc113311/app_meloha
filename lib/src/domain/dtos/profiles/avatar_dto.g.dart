// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'avatar_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AvatarProfileDto _$AvatarProfileDtoFromJson(Map<String, dynamic> json) =>
    AvatarProfileDto(
      json['msgKey'] as String,
      json['message'] as String,
      (json['count'] as num).toInt(),
      (json['data'] as List<dynamic>)
          .map((e) => AvatarDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AvatarProfileDtoToJson(AvatarProfileDto instance) =>
    <String, dynamic>{
      'msgKey': instance.msgKey,
      'message': instance.message,
      'count': instance.count,
      'data': instance.data,
    };

AvatarDto _$AvatarDtoFromJson(Map<String, dynamic> json) => AvatarDto(
      meta: ImageMetaDto.fromJson(json['meta'] as Map<String, dynamic>),
      id: json['id'] as String?,
      reviewerStatus: (json['reviewerStatus'] as num?)?.toInt() ?? 0,
      order: (json['order'] as num?)?.toInt() ?? 0,
      comment: json['comment'] as String? ?? '',
      reviewerViolateOption: (json['reviewerViolateOption'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      aiStatus: (json['aiStatus'] as num?)?.toInt() ?? 0,
      aiViolateOption: (json['aiViolateOption'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      aiPoint: (json['aiPoint'] as num?)?.toDouble() ?? 0,
      isVerified: json['isVerified'] as bool? ?? false,
      insert: json['insert'] == null
          ? null
          : InsertDto.fromJson(json['insert'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AvatarDtoToJson(AvatarDto instance) => <String, dynamic>{
      'id': instance.id,
      'meta': instance.meta,
      'reviewerStatus': instance.reviewerStatus,
      'order': instance.order,
      'comment': instance.comment,
      'reviewerViolateOption': instance.reviewerViolateOption,
      'aiStatus': instance.aiStatus,
      'aiViolateOption': instance.aiViolateOption,
      'aiPoint': instance.aiPoint,
      'isVerified': instance.isVerified,
      'insert': instance.insert,
    };

ImageMetaDto _$ImageMetaDtoFromJson(Map<String, dynamic> json) => ImageMetaDto(
      url: json['url'] as String,
      thumbnails: (json['thumbnails'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ImageMetaDtoToJson(ImageMetaDto instance) =>
    <String, dynamic>{
      'url': instance.url,
      'thumbnails': instance.thumbnails,
    };
