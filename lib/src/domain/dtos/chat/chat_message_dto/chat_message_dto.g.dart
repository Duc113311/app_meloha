// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageResponseDto _$MessageResponseDtoFromJson(Map<String, dynamic> json) =>
    MessageResponseDto(
      record: MessageDto.fromJson(json['record'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MessageResponseDtoToJson(MessageResponseDto instance) =>
    <String, dynamic>{
      'record': instance.record,
    };

MessageDto _$MessageDtoFromJson(Map<String, dynamic> json) => MessageDto(
      id: json['_id'] as String,
      content: MessageContent.fromJson(json['message'] as Map<String, dynamic>),
      listUserReceived: (json['listUserReceived'] as List<dynamic>?)
          ?.map((e) => UserReceivedDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      listUserSeen: (json['listUserSeen'] as List<dynamic>?)
          ?.map((e) => UserReceivedDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      hideWithIds: (json['hideWithIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      channelId: json['channelId'] as String?,
      senderId: json['senderId'] as String?,
      insert: ChatInsertDto.fromJson(json['insert'] as Map<String, dynamic>),
      previewData: json['previewData'] == null
          ? null
          : PreviewData.fromJson(json['previewData'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MessageDtoToJson(MessageDto instance) =>
    <String, dynamic>{
      'message': instance.content,
      'listUserReceived': instance.listUserReceived,
      'listUserSeen': instance.listUserSeen,
      'hideWithIds': instance.hideWithIds,
      '_id': instance.id,
      'channelId': instance.channelId,
      'senderId': instance.senderId,
      'insert': instance.insert,
      'previewData': instance.previewData,
    };

MessageContent _$MessageContentFromJson(Map<String, dynamic> json) =>
    MessageContent(
      text: json['text'] as String,
      image: json['image'] as String? ?? "",
    )
      ..icons =
          (json['icons'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              []
      ..reacts = (json['reacts'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [];

Map<String, dynamic> _$MessageContentToJson(MessageContent instance) =>
    <String, dynamic>{
      'text': instance.text,
      'image': instance.image,
      'icons': instance.icons,
      'reacts': instance.reacts,
    };

UserReceivedDto _$UserReceivedDtoFromJson(Map<String, dynamic> json) =>
    UserReceivedDto(
      when: (json['when'] as num).toInt(),
      by: json['by'] as String,
    );

Map<String, dynamic> _$UserReceivedDtoToJson(UserReceivedDto instance) =>
    <String, dynamic>{
      'when': instance.when,
      'by': instance.by,
    };
