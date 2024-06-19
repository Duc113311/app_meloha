// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_friends_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListFriendsDto _$ListFriendsDtoFromJson(Map<String, dynamic> json) =>
    ListFriendsDto(
      currentPage: (json['currentPage'] as num).toInt(),
      skip: (json['skip'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
      count: (json['count'] as num).toInt(),
      total: (json['total'] as num).toInt(),
      listData: (json['list_data'] as List<dynamic>?)
          ?.map((e) => CustomerDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ListFriendsDtoToJson(ListFriendsDto instance) =>
    <String, dynamic>{
      'currentPage': instance.currentPage,
      'skip': instance.skip,
      'limit': instance.limit,
      'count': instance.count,
      'total': instance.total,
      'list_data': instance.listData,
    };
