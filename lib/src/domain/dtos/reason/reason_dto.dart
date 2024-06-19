import 'package:json_annotation/json_annotation.dart';

part 'reason_dto.g.dart';

@JsonSerializable()
class ReasonResponseDto {
  @JsonKey(name: 'reason')
  List<ReasonDto> reasons;

  ReasonResponseDto({
    required this.reasons,
  });

  factory ReasonResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ReasonResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ReasonResponseDtoToJson(this);
}

@JsonSerializable()
class ReasonDto {
  @JsonKey(name: 'code', defaultValue: '')
  String code;

  @JsonKey(name: 'value', defaultValue: '')
  String value;

  @JsonKey(name: 'codeReason')
  List<CodeReason> codeReasons;

  ReasonDto({
    required this.code,
    required this.value,
    required this.codeReasons,
  });

  factory ReasonDto.fromJson(Map<String, dynamic> json) =>
      _$ReasonDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ReasonDtoToJson(this);
}

@JsonSerializable()
class CodeReason {
  @JsonKey(name: 'codeTitle')
  String codeTitle;

  @JsonKey(name: 'value')
  String value;

  @JsonKey(name: 'codeReasonDetail')
  List<CodeReasonDetail> codeReasonDetails;

  CodeReason(this.codeTitle, this.value, this.codeReasonDetails);

  factory CodeReason.fromJson(Map<String, dynamic> json) =>
      _$CodeReasonFromJson(json);

  Map<String, dynamic> toJson() => _$CodeReasonToJson(this);
}

@JsonSerializable()
class CodeReasonDetail {
  @JsonKey(name: 'codeDetail', defaultValue: '')
  String codeDetail;

  @JsonKey(name: 'value', defaultValue: '')
  String value;

  CodeReasonDetail({
    required this.codeDetail,
    required this.value,
  });

  factory CodeReasonDetail.fromJson(Map<String, dynamic> json) =>
      _$CodeReasonDetailFromJson(json);

  Map<String, dynamic> toJson() => _$CodeReasonDetailToJson(this);
}
