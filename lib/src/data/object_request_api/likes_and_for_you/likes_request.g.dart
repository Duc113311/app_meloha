// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'likes_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LikesRequest _$LikesRequestFromJson(Map<String, dynamic> json) => LikesRequest(
      (json['pageSize'] as num).toInt(),
      (json['currentPage'] as num).toInt(),
      json['action'] as String? ?? 'like',
    );

Map<String, dynamic> _$LikesRequestToJson(LikesRequest instance) =>
    <String, dynamic>{
      'pageSize': instance.pageSize,
      'currentPage': instance.currentPage,
      'action': instance.action,
    };

ForYouRequest _$ForYouRequestFromJson(Map<String, dynamic> json) =>
    ForYouRequest(
      (json['pageSize'] as num).toInt(),
    );

Map<String, dynamic> _$ForYouRequestToJson(ForYouRequest instance) =>
    <String, dynamic>{
      'pageSize': instance.pageSize,
    };
