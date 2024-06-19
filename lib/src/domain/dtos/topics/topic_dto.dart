import 'package:json_annotation/json_annotation.dart';

part 'topic_dto.g.dart';

@JsonSerializable()
class ListTopicDto {
  @JsonKey(name: 'msgKey')
  final String msgKey;
  @JsonKey(name: 'message')
  final String message;
  @JsonKey(name: 'count')
  final int count;
  @JsonKey(name: 'data')
  final List<TopicDto> data;

  ListTopicDto(this.msgKey, this.message, this.count, this.data);

  factory ListTopicDto.fromJson(Map<String, dynamic> json) => _$ListTopicDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ListTopicDtoToJson(this);
}

@JsonSerializable()
class TopicDto {
  @JsonKey(name: '_id')
  final String id;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'image')
  final String image;
  @JsonKey(name: 'description')
  final String description;
  @JsonKey(name: 'typeExplore')
  final int typeExplore;

  TopicDto(this.id, this.name, this.image, this.description, this.typeExplore);

  factory TopicDto.fromJson(Map<String, dynamic> json) => _$TopicDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TopicDtoToJson(this);
}