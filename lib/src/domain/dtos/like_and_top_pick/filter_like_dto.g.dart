// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter_like_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FilterLikeDto _$FilterLikeDtoFromJson(Map<String, dynamic> json) =>
    FilterLikeDto(
      msgKey: json['msgKey'] as String,
      message: json['message'] as String,
      data: FilterLikeDataDto.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FilterLikeDtoToJson(FilterLikeDto instance) =>
    <String, dynamic>{
      'msgKey': instance.msgKey,
      'message': instance.message,
      'data': instance.data,
    };

FilterLikeDataDto _$FilterLikeDataDtoFromJson(Map<String, dynamic> json) =>
    FilterLikeDataDto(
      currentPage: (json['currentPage'] as num).toInt(),
      skip: (json['skip'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
      count: (json['count'] as num).toInt(),
      total: (json['total'] as num).toInt(),
      listData: (json['list_data'] as List<dynamic>)
          .map((e) => CustomersLikeTopDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FilterLikeDataDtoToJson(FilterLikeDataDto instance) =>
    <String, dynamic>{
      'currentPage': instance.currentPage,
      'skip': instance.skip,
      'limit': instance.limit,
      'count': instance.count,
      'total': instance.total,
      'list_data': instance.listData,
    };

FilterBodyDto _$FilterBodyDtoFromJson(Map<String, dynamic> json) =>
    FilterBodyDto(
      distance: (json['distance'] as num).toDouble(),
      ageMin: (json['ageMin'] as num).toInt(),
      ageMax: (json['ageMax'] as num).toInt(),
      numberPhoto: (json['numberPhoto'] as num).toInt(),
      interests:
          (json['interests'] as List<dynamic>).map((e) => e as String).toList(),
      statusVerified: json['statusVerified'] as bool,
      statusBio: json['statusBio'] as bool,
      lat: (json['lat'] as num).toDouble(),
      long: (json['long'] as num).toDouble(),
    );

Map<String, dynamic> _$FilterBodyDtoToJson(FilterBodyDto instance) =>
    <String, dynamic>{
      'distance': instance.distance,
      'ageMin': instance.ageMin,
      'ageMax': instance.ageMax,
      'numberPhoto': instance.numberPhoto,
      'interests': instance.interests,
      'statusVerified': instance.statusVerified,
      'statusBio': instance.statusBio,
      'lat': instance.lat,
      'long': instance.long,
    };
