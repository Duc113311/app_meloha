import 'package:dating_app/src/domain/dtos/customers/customers_dto.dart';
import 'package:json_annotation/json_annotation.dart';

import '../chat_message_dto/chat_message_dto.dart';

part 'get_channels_dto.g.dart';

@JsonSerializable()
class ListChannelsDto {
  @JsonKey(name: 'currentPage')
  int currentPage;

  @JsonKey(name: 'skip')
  int skip;

  @JsonKey(name: 'limit')
  int limit;

  @JsonKey(name: 'count')
  int count;

  @JsonKey(name: 'total')
  int total;

  @JsonKey(name: 'list_data')
  List<ChannelDto> listData;

  ListChannelsDto({
    required this.currentPage,
    required this.skip,
    required this.limit,
    required this.count,
    required this.total,
    required this.listData,
  });

  factory ListChannelsDto.fromJson(Map<String, dynamic> json) =>
      _$ListChannelsDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ListChannelsDtoToJson(this);
}

@JsonSerializable()
class ChannelDto {

  @JsonKey(name: 'channelId')
  String channelId;

  @JsonKey(name: 'clients')
  List<CustomerDto?> clients;

  @JsonKey(name: 'summary')
  ChannelSummary? summary;

  @JsonKey(name: 'lastMessage')
  MessageDto? lastMessage;


  ChannelDto({
    required this.channelId,
    required this.clients,
    this.summary,
    this.lastMessage,
  });

  factory ChannelDto.fromJson(Map<String, dynamic> json) =>
      _$ChannelDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ChannelDtoToJson(this);
}

@JsonSerializable()
class ChannelSummary {

  @JsonKey(name: 'total')
  int total;

  @JsonKey(name: 'numUnRead')
  int numUnRead;

  @JsonKey(name: 'numNotReceived')
  int numNotReceived;

  ChannelSummary({
    required this.total,
    required this.numUnRead,
    required this.numNotReceived,
  });

  factory ChannelSummary.fromJson(Map<String, dynamic> json) =>
      _$ChannelSummaryFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ChannelSummaryToJson(this);
}

// @JsonSerializable()
// class LastMessage {
//
//   @JsonKey(name: '_id')
//   String id;
//
//   @JsonKey(name: 'message')
//   MessageContent message;
//
//   @JsonKey(name: 'listUserReceived')
//   List<UserReceivedDto> listUserReceived;
//
//   @JsonKey(name: 'listUserSeen')
//   List<UserReceivedDto> listUserSeen;
//
//   @JsonKey(name: 'hideWithIds')
//   List<String> hideWithIds;
//
//   @JsonKey(name: 'channelId')
//   String channelId;
//
//   @JsonKey(name: 'senderId')
//   String senderId;
//
//   @JsonKey(name: 'insert')
//   ChatInsertDto insert;
//
//   LastMessage({
//     required this.id,
//     required this.message,
//     required this.listUserReceived,
//     required this.listUserSeen,
//     required this.hideWithIds,
//     required this.channelId,
//     required this.senderId,
//     required this.insert,
//   });
//
//   factory LastMessage.fromJson(Map<String, dynamic> json) =>
//       _$LastMessageFromJson(json);
//
//   @override
//   Map<String, dynamic> toJson() => _$LastMessageToJson(this);
// }