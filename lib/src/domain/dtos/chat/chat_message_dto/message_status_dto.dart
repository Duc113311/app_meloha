
import 'package:json_annotation/json_annotation.dart';

part 'message_status_dto.g.dart';

@JsonSerializable()
class UpdateMessageDTO {

  @JsonKey(name: 'msgIds')
  List<String> msgIds;

  @JsonKey(name: 'status')
  int status;

  UpdateMessageDTO({
    required this.msgIds,
    required this.status,
  }) : super();

  factory UpdateMessageDTO.fromJson(Map<String, dynamic> json) =>
      _$UpdateMessageDTOFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UpdateMessageDTOToJson(this);

}