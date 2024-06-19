// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customers_like_top_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LikeTopDto _$LikeTopDtoFromJson(Map<String, dynamic> json) => LikeTopDto(
      skip: (json['skip'] as num?)?.toInt(),
      limit: (json['limit'] as num?)?.toInt(),
      currentPage: (json['currentPage'] as num?)?.toInt(),
      count: (json['count'] as num?)?.toInt(),
      listData: (json['list_data'] as List<dynamic>?)
          ?.map((e) => CustomersLikeTopDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num?)?.toInt(),
    );

Map<String, dynamic> _$LikeTopDtoToJson(LikeTopDto instance) =>
    <String, dynamic>{
      'skip': instance.skip,
      'limit': instance.limit,
      'currentPage': instance.currentPage,
      'count': instance.count,
      'list_data': instance.listData,
      'total': instance.total,
    };

CustomersLikeTopDto _$CustomersLikeTopDtoFromJson(Map<String, dynamic> json) =>
    CustomersLikeTopDto(
      profilesDto:
          ProfilesDto.fromJson(json['profiles'] as Map<String, dynamic>),
      onlineNow: json['onlineNow'] as bool? ?? false,
      id: json['_id'] as String,
      fullName: json['fullname'] as String,
      phone: json['phone'] as String?,
      dob: CustomersLikeTopDto._dob(json['dob'] as String?),
      distanceKm: (json['distanceKm'] as num?)?.toDouble() ?? 0,
      explore: json['explore'] == null
          ? null
          : ExploreDto.fromJson(json['explore'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CustomersLikeTopDtoToJson(
        CustomersLikeTopDto instance) =>
    <String, dynamic>{
      'profiles': instance.profilesDto,
      'onlineNow': instance.onlineNow,
      '_id': instance.id,
      'fullname': instance.fullName,
      'phone': instance.phone,
      'dob': instance.dob?.toIso8601String(),
      'distanceKm': instance.distanceKm,
      'explore': instance.explore,
    };
