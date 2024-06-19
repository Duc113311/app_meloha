// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_messages_in_chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListMessagesDto _$ListMessagesDtoFromJson(Map<String, dynamic> json) =>
    ListMessagesDto(
      channelId: json['channelId'] as String,
      currentPage: (json['currentPage'] as num).toInt(),
      skip: (json['skip'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
      count: (json['count'] as num).toInt(),
      total: (json['total'] as num).toInt(),
      listData: (json['list_data'] as List<dynamic>?)
          ?.map((e) => MessageDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      clients: (json['clients'] as List<dynamic>)
          .map((e) => CustomerDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ListMessagesDtoToJson(ListMessagesDto instance) =>
    <String, dynamic>{
      'channelId': instance.channelId,
      'currentPage': instance.currentPage,
      'skip': instance.skip,
      'limit': instance.limit,
      'count': instance.count,
      'total': instance.total,
      'list_data': instance.listData,
      'clients': instance.clients,
    };
