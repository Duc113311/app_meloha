// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginDto _$LoginDtoFromJson(Map<String, dynamic> json) => LoginDto(
      json['token'] as String,
      CustomerDto.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LoginDtoToJson(LoginDto instance) => <String, dynamic>{
      'token': instance.token,
      'user': instance.user,
    };

BlockedAccountDto _$BlockedAccountDtoFromJson(Map<String, dynamic> json) =>
    BlockedAccountDto(
      json['msgKey'] as String,
      json['message'] as String,
      json['extra_info'] == null
          ? null
          : BlockedExtraInfoDto.fromJson(
              json['extra_info'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BlockedAccountDtoToJson(BlockedAccountDto instance) =>
    <String, dynamic>{
      'msgKey': instance.msgKey,
      'message': instance.message,
      'extra_info': instance.extraInfo,
    };

BlockedExtraInfoDto _$BlockedExtraInfoDtoFromJson(Map<String, dynamic> json) =>
    BlockedExtraInfoDto(
      DateTime.parse(json['toDate'] as String),
      json['disable'] as bool? ?? false,
    );

Map<String, dynamic> _$BlockedExtraInfoDtoToJson(
        BlockedExtraInfoDto instance) =>
    <String, dynamic>{
      'toDate': instance.toDate.toIso8601String(),
      'disable': instance.disable,
    };

LoginErrorDto _$LoginErrorDtoFromJson(Map<String, dynamic> json) =>
    LoginErrorDto(
      responseCode: (json['responseCode'] as num).toInt(),
      errorMessage: json['errorMessage'] as String?,
    );

Map<String, dynamic> _$LoginErrorDtoToJson(LoginErrorDto instance) =>
    <String, dynamic>{
      'errorMessage': instance.errorMessage,
      'responseCode': instance.responseCode,
    };
