import 'package:dating_app/src/domain/dtos/like_and_top_pick/customers_like_top_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'filter_like_dto.g.dart';

@JsonSerializable()
class FilterLikeDto {
  @JsonKey(name: 'msgKey')
  final String msgKey;
  @JsonKey(name: 'message')
  final String message;
  @JsonKey(name: 'data')
  final FilterLikeDataDto data;

  FilterLikeDto({
    required this.msgKey,
    required this.message,
    required this.data,
  }) : super();

  factory FilterLikeDto.fromJson(Map<String, dynamic> json) =>
      _$FilterLikeDtoFromJson(json);

  Map<String, dynamic> toJson() => _$FilterLikeDtoToJson(this);
}

@JsonSerializable()
class FilterLikeDataDto {
  @JsonKey(name: 'currentPage')
  final int currentPage;
  @JsonKey(name: 'skip')
  final int skip;
  @JsonKey(name: 'limit')
  final int limit;
  @JsonKey(name: 'count')
  final int count;
  @JsonKey(name: 'total')
  final int total;
  @JsonKey(name: 'list_data')
  final List<CustomersLikeTopDto> listData;

  FilterLikeDataDto({
    required this.currentPage,
    required this.skip,
    required this.limit,
    required this.count,
    required this.total,
    required this.listData,
  }) : super();

  factory FilterLikeDataDto.fromJson(Map<String, dynamic> json) =>
      _$FilterLikeDataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$FilterLikeDataDtoToJson(this);
}

@JsonSerializable()
class FilterBodyDto {
  @JsonKey(name: 'distance')
  double distance;
  @JsonKey(name: 'ageMin')
  int ageMin;
  @JsonKey(name: 'ageMax')
  int ageMax;
  @JsonKey(name: 'numberPhoto')
  int numberPhoto;
  @JsonKey(name: 'interests')
  List<String> interests;
  @JsonKey(name: 'statusVerified')
  bool statusVerified;
  @JsonKey(name: 'statusBio')
  bool statusBio;
  @JsonKey(name: 'lat')
  double lat;
  @JsonKey(name: 'long')
  double long;

  FilterBodyDto({
    required this.distance,
    required this.ageMin,
    required this.ageMax,
    required this.numberPhoto,
    required this.interests,
    required this.statusVerified,
    required this.statusBio,
    required this.lat,
    required this.long,
  }) : super();

  factory FilterBodyDto.fromJson(Map<String, dynamic> json) =>
      _$FilterBodyDtoFromJson(json);

  Map<String, dynamic> toJson() => _$FilterBodyDtoToJson(this);
}