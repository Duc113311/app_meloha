import 'package:json_annotation/json_annotation.dart';

import '../../../utils/date_time_utils.dart';
part 'card_action_dto.g.dart';
@JsonSerializable()
class NopeDto {

  @JsonKey(name: 'isMatched')
  final bool? isMatched;



  NopeDto({ this.isMatched}) : super();

  factory NopeDto.fromJson(Map<String, dynamic> json) =>
      _$NopeDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$NopeDtoToJson(this);
}

@JsonSerializable()
class LikeDto {
  @JsonKey(name: 'isMatched')
  final bool? isMatched;



  LikeDto({ this.isMatched}) : super();

  factory LikeDto.fromJson(Map<String, dynamic> json) =>
      _$LikeDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$LikeDtoToJson(this);
}

@JsonSerializable()
class BoostResponseDto {
  @JsonKey(name: 'msgKey')
  final String? msgKey;
  @JsonKey(name: 'message')
  final String? message;

  @JsonKey(name: 'data')
  BoostDto? data;

  BoostResponseDto({this.msgKey, this.message, this.data});

  factory BoostResponseDto.fromJson(Map<String, dynamic> json) =>
      _$BoostResponseDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$BoostResponseDtoToJson(this);
}
@JsonSerializable()
class BoostDto {

  @JsonKey(name: '_id')
  final String? id;
  @JsonKey(name: 'customer')
  final String? customer;
  @JsonKey(name: 'startTime')
  final DateTime? startTime;
  @JsonKey(name: 'endTime')
  final DateTime? endTime;
  @JsonKey(name: 'duration')
  final int? duration;
  @JsonKey(name: 'boostRemaining')
  final int? boostRemaining;
  @JsonKey(name: 'isFreeRuntime')
  final bool? isFreeRuntime;



  BoostDto( {this.id, this.customer, this.startTime, this.endTime, this.duration, this.boostRemaining, this.isFreeRuntime,}) : super();

  //from json
  factory BoostDto.fromJson(Map<String, dynamic> json) =>
      _$BoostDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$BoostDtoToJson(this);
}