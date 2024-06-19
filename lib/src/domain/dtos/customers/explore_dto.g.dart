// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'explore_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExploreDto _$ExploreDtoFromJson(Map<String, dynamic> json) => ExploreDto(
      verified: (json['verified'] as num?)?.toInt() ?? 0,
      topics: (json['topics'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$ExploreDtoToJson(ExploreDto instance) =>
    <String, dynamic>{
      'verified': instance.verified,
      'topics': instance.topics,
    };

PlusCtrlDto _$PlusCtrlDtoFromJson(Map<String, dynamic> json) => PlusCtrlDto(
      whoSeeYou: json['whoSeeYou'] as String,
      whoYouSee: json['whoYouSee'] as String,
    );

Map<String, dynamic> _$PlusCtrlDtoToJson(PlusCtrlDto instance) =>
    <String, dynamic>{
      'whoYouSee': instance.whoYouSee,
      'whoSeeYou': instance.whoSeeYou,
    };
