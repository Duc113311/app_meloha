
import 'package:json_annotation/json_annotation.dart';

import 'customers_dto.dart';
part 'login_dto.g.dart';
@JsonSerializable()
class LoginDto {
  @JsonKey(name: 'token')
  String token;

  @JsonKey(name: 'user')
  CustomerDto user;

  LoginDto(this.token, this.user);

  factory LoginDto.fromJson(Map<String, dynamic> json) =>
      _$LoginDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$LoginDtoToJson(this);
}

@JsonSerializable()
class BlockedAccountDto {
  @JsonKey(name: 'msgKey')
  String msgKey;

  @JsonKey(name: 'message')
  String message;

  @JsonKey(name: 'extra_info')
  BlockedExtraInfoDto? extraInfo;

  BlockedAccountDto(this.msgKey, this.message, this.extraInfo);

  factory BlockedAccountDto.fromJson(Map<String, dynamic> json) =>
      _$BlockedAccountDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$BlockedAccountDtoToJson(this);
}

@JsonSerializable()
class BlockedExtraInfoDto {
  @JsonKey(name: 'toDate')
  DateTime toDate;

  @JsonKey(name: 'disable', defaultValue: false)
  bool? disable;

  BlockedExtraInfoDto(this.toDate, this.disable);

  factory BlockedExtraInfoDto.fromJson(Map<String, dynamic> json) =>
      _$BlockedExtraInfoDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$BlockedExtraInfoDtoToJson(this);
}

@JsonSerializable()
class LoginErrorDto {
  String? errorMessage;
  int responseCode;
  LoginErrorDto({required this.responseCode, this.errorMessage});

}
