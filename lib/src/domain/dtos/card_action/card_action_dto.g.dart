// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_action_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NopeDto _$NopeDtoFromJson(Map<String, dynamic> json) => NopeDto(
      isMatched: json['isMatched'] as bool?,
    );

Map<String, dynamic> _$NopeDtoToJson(NopeDto instance) => <String, dynamic>{
      'isMatched': instance.isMatched,
    };

LikeDto _$LikeDtoFromJson(Map<String, dynamic> json) => LikeDto(
      isMatched: json['isMatched'] as bool?,
    );

Map<String, dynamic> _$LikeDtoToJson(LikeDto instance) => <String, dynamic>{
      'isMatched': instance.isMatched,
    };

BoostResponseDto _$BoostResponseDtoFromJson(Map<String, dynamic> json) =>
    BoostResponseDto(
      msgKey: json['msgKey'] as String?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : BoostDto.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BoostResponseDtoToJson(BoostResponseDto instance) =>
    <String, dynamic>{
      'msgKey': instance.msgKey,
      'message': instance.message,
      'data': instance.data,
    };

BoostDto _$BoostDtoFromJson(Map<String, dynamic> json) => BoostDto(
      id: json['_id'] as String?,
      customer: json['customer'] as String?,
      startTime: json['startTime'] == null
          ? null
          : DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
      duration: (json['duration'] as num?)?.toInt(),
      boostRemaining: (json['boostRemaining'] as num?)?.toInt(),
      isFreeRuntime: json['isFreeRuntime'] as bool?,
    );

Map<String, dynamic> _$BoostDtoToJson(BoostDto instance) => <String, dynamic>{
      '_id': instance.id,
      'customer': instance.customer,
      'startTime': instance.startTime?.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'duration': instance.duration,
      'boostRemaining': instance.boostRemaining,
      'isFreeRuntime': instance.isFreeRuntime,
    };
