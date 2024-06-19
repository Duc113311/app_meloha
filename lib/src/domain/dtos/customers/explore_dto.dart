import 'package:json_annotation/json_annotation.dart';

part 'explore_dto.g.dart';

@JsonSerializable()
class ExploreDto {
  @JsonKey(name: 'verified', defaultValue: 0)
  int verified;

  @JsonKey(name: 'topics', defaultValue: [])
  final List<String> topics;

  ExploreDto({required this.verified, required this.topics});

  factory ExploreDto.fromJson(Map<String, dynamic> json) =>
      _$ExploreDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ExploreDtoToJson(this);
}


@JsonSerializable()
class PlusCtrlDto {
  @JsonKey(name: 'whoYouSee')
  String whoYouSee;

  @JsonKey(name: 'whoSeeYou')
  String whoSeeYou;

  PlusCtrlDto({required this.whoSeeYou, required this.whoYouSee});

  factory PlusCtrlDto.fromJson(Map<String, dynamic> json) =>
      _$PlusCtrlDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PlusCtrlDtoToJson(this);
}