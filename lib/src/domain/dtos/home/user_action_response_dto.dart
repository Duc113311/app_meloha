import 'package:json_annotation/json_annotation.dart';

part 'user_action_response_dto.g.dart';

@JsonSerializable()
class UserActionResponse {
  @JsonKey(name: 'isMatched')
  bool isMatched;

  @JsonKey(name: 'isFreeRuntime')
  bool isFreeRuntime;

  @JsonKey(name: 'likeRemaining')
  int likeRemaining;

  UserActionResponse(this.isMatched, this.isFreeRuntime, this.likeRemaining);

  factory UserActionResponse.fromJson(Map<String, dynamic> json) =>
      _$UserActionResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UserActionResponseToJson(this);
}
