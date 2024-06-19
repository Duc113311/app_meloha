import 'package:json_annotation/json_annotation.dart';

part 'base_dto.g.dart';


@JsonSerializable()
class BaseDto {
  @JsonKey(required: false, defaultValue: '')
  String message;
  @JsonKey(required: false, defaultValue: '')
  String data;

  BaseDto(this.message, this.data);

  factory BaseDto.fromJson(Map<String, dynamic> json) =>
      _$BaseDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$BaseDtoToJson(this);
}