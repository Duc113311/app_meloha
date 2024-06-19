// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_status_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateMessageDTO _$UpdateMessageDTOFromJson(Map<String, dynamic> json) =>
    UpdateMessageDTO(
      msgIds:
          (json['msgIds'] as List<dynamic>).map((e) => e as String).toList(),
      status: (json['status'] as num).toInt(),
    );

Map<String, dynamic> _$UpdateMessageDTOToJson(UpdateMessageDTO instance) =>
    <String, dynamic>{
      'msgIds': instance.msgIds,
      'status': instance.status,
    };
