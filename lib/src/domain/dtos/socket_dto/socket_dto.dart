import 'package:json_annotation/json_annotation.dart';
part 'socket_dto.g.dart';

@JsonSerializable()
class SocketNewLikeDto {
  @JsonKey(name: 'action')
  String action;

  @JsonKey(name: 'isMatched')
  bool isMatched;


  SocketNewLikeDto({
    required this.action,
    required this.isMatched,
  });

  factory SocketNewLikeDto.fromJson(Map<String, dynamic> json) =>
      _$SocketNewLikeDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SocketNewLikeDtoToJson(this);

  //Utils
  SocketActionType get actionType {
    if (action == SocketActionType.like.name) {
      return SocketActionType.like;
    } else {
      return SocketActionType.superLike;
    }
  }

}

enum SocketActionType {
  like, superLike //superLike is super_like
}