// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_channels_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListChannelsDto _$ListChannelsDtoFromJson(Map<String, dynamic> json) =>
    ListChannelsDto(
      currentPage: (json['currentPage'] as num).toInt(),
      skip: (json['skip'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
      count: (json['count'] as num).toInt(),
      total: (json['total'] as num).toInt(),
      listData: (json['list_data'] as List<dynamic>)
          .map((e) => ChannelDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ListChannelsDtoToJson(ListChannelsDto instance) =>
    <String, dynamic>{
      'currentPage': instance.currentPage,
      'skip': instance.skip,
      'limit': instance.limit,
      'count': instance.count,
      'total': instance.total,
      'list_data': instance.listData,
    };

ChannelDto _$ChannelDtoFromJson(Map<String, dynamic> json) => ChannelDto(
      channelId: json['channelId'] as String,
      clients: (json['clients'] as List<dynamic>)
          .map((e) => e == null
              ? null
              : CustomerDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      summary: json['summary'] == null
          ? null
          : ChannelSummary.fromJson(json['summary'] as Map<String, dynamic>),
      lastMessage: json['lastMessage'] == null
          ? null
          : MessageDto.fromJson(json['lastMessage'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChannelDtoToJson(ChannelDto instance) =>
    <String, dynamic>{
      'channelId': instance.channelId,
      'clients': instance.clients,
      'summary': instance.summary,
      'lastMessage': instance.lastMessage,
    };

ChannelSummary _$ChannelSummaryFromJson(Map<String, dynamic> json) =>
    ChannelSummary(
      total: (json['total'] as num).toInt(),
      numUnRead: (json['numUnRead'] as num).toInt(),
      numNotReceived: (json['numNotReceived'] as num).toInt(),
    );

Map<String, dynamic> _$ChannelSummaryToJson(ChannelSummary instance) =>
    <String, dynamic>{
      'total': instance.total,
      'numUnRead': instance.numUnRead,
      'numNotReceived': instance.numNotReceived,
    };
