import 'package:json_annotation/json_annotation.dart';

part 'get_channel_id.g.dart';

@JsonSerializable()
class ChannelIdDto {
  @JsonKey(name: 'channelId')
  String channelId;

  ChannelIdDto({
    required this.channelId
  });

  factory ChannelIdDto.fromJson(Map<String, dynamic> json) =>
      _$ChannelIdDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ChannelIdDtoToJson(this);
}