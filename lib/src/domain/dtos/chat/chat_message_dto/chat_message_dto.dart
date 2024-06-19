import 'package:dating_app/src/requests/api_utils.dart';
import 'package:dating_app/src/utils/pref_assist.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../../chatUI/chat_type/preview_data.dart';
import '../../general/insert_dto.dart';
import 'message_received_type.dart';

part 'chat_message_dto.g.dart';

@JsonSerializable()
class MessageResponseDto {
  @JsonKey(name: 'record')
  MessageDto record;

  MessageResponseDto({
    required this.record,
  }) : super();

  factory MessageResponseDto.fromJson(Map<String, dynamic> json) =>
      _$MessageResponseDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$MessageResponseDtoToJson(this);
}

@JsonSerializable()
class MessageDto {
  @JsonKey(
    name: 'message',
  )
  MessageContent content;

  @JsonKey(name: 'listUserReceived')
  List<UserReceivedDto>? listUserReceived;

  @JsonKey(name: 'listUserSeen')
  List<UserReceivedDto>? listUserSeen;

  @JsonKey(name: 'hideWithIds')
  List<String>? hideWithIds;

  @JsonKey(name: '_id')
  String id;

  @JsonKey(name: 'channelId')
  String? channelId;

  @JsonKey(name: 'senderId')
  String? senderId;

  @JsonKey(name: 'insert')
  ChatInsertDto insert;

  PreviewData? previewData;

  MessageDto(
      {required this.id,
      required this.content,
      this.listUserReceived,
      this.listUserSeen,
      this.hideWithIds,
      this.channelId,
      this.senderId,
      required this.insert,
      this.previewData})
      : super();

  factory MessageDto.fromJson(Map<String, dynamic> json) =>
      _$MessageDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$MessageDtoToJson(this);

  MessageStatusType getStatus() {
    if (listUserSeen?.isNotEmpty ?? false) {
      return MessageStatusType.seen;
    } else if (listUserReceived?.isNotEmpty ?? false) {
      return MessageStatusType.delivered;
    } else {
      return MessageStatusType.created;
    }
  }

  bool isAuthor() {
    return id == PrefAssist.getMyCustomer().id;
  }

  int getSort() {
    return (listUserReceived ?? []).length +
        (listUserSeen ?? []).length +
        (hideWithIds ?? []).length;
  }

  String get text {
    return content.text;
  }
}

@JsonSerializable()
class MessageContent {
  @JsonKey(name: 'text')
  String text;

  @JsonKey(name: 'image')
  String image;

  @JsonKey(name: 'icons', defaultValue: [])
  List<String> icons = [];

  @JsonKey(name: 'reacts', defaultValue: [])
  List<String> reacts = [];

  MessageContent({required this.text, this.image = ""});

  factory MessageContent.fromJson(Map<String, dynamic> json) =>
      _$MessageContentFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$MessageContentToJson(this);
}

@JsonSerializable()
class UserReceivedDto {
  @JsonKey(name: 'when')
  int when;

  @JsonKey(name: 'by')
  String by;

  UserReceivedDto({required this.when, required this.by}) : super();

  factory UserReceivedDto.fromJson(Map<String, dynamic> json) =>
      _$UserReceivedDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UserReceivedDtoToJson(this);
}
