
import 'package:dating_app/src/domain/dtos/general/insert_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'avatar_dto.g.dart';

@JsonSerializable()
class AvatarProfileDto {
  @JsonKey(name: 'msgKey')
  final String msgKey;

  @JsonKey(name: 'message')
  final String message;

  @JsonKey(name: 'count')
  final int count;

  @JsonKey(name: 'data')
  final List<AvatarDto> data;

  factory AvatarProfileDto.fromJson(Map<String, dynamic> json) =>
      _$AvatarProfileDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AvatarProfileDtoToJson(this);

  AvatarProfileDto(this.msgKey, this.message, this.count, this.data);
}

@JsonSerializable()
class AvatarDto {
  @JsonKey(name: 'id')
  String? id;
  @JsonKey(name: 'meta')
  ImageMetaDto meta;
  @JsonKey(name: 'reviewerStatus', defaultValue: 0)
  int? reviewerStatus;
  @JsonKey(name: 'order', defaultValue: 0)
  int? order;
  @JsonKey(name: 'comment', defaultValue: '')
  String? comment;
  @JsonKey(name: 'reviewerViolateOption', defaultValue: [])
  List<String> reviewerViolateOption;
  @JsonKey(name: 'aiStatus', defaultValue: 0)
  int? aiStatus;
  @JsonKey(name: 'aiViolateOption', defaultValue: [])
  List<String> aiViolateOption;
  @JsonKey(name: 'aiPoint', defaultValue: 0)
  double? aiPoint;
  @JsonKey(name: 'isVerified', defaultValue: false)
  bool? isVerified;
  @JsonKey(name: 'insert')
  InsertDto? insert;

  String get url {
    return meta.url;
  }

  String get cacheKeyId {
    return meta.url.split("?").first;
  }

  String get thumbnail {
    return meta.thumbnails.firstOrNull ?? url;
  }

  bool get getVerified {
    return isVerified ?? false;
  }

  factory AvatarDto.fromJson(Map<String, dynamic> json) =>
      _$AvatarDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AvatarDtoToJson(this);

  // static AvatarDto createEmptyAvatar(ImageMetaDto meta) {
  //   return AvatarDto(meta: meta, reviewerStatus: false, order: false);
  // }

  AvatarDto({required this.meta, this.id, this.reviewerStatus = 0, this.order = 0, this.comment = '', required this.reviewerViolateOption, this.aiStatus = 0, required this.aiViolateOption, this.aiPoint = 0, this.isVerified = false, this.insert}): super();
}


@JsonSerializable()
class ImageMetaDto {
  @JsonKey(name: 'url')
  String url;
  @JsonKey(name: 'thumbnails')
  List<String> thumbnails;


  ImageMetaDto({required this.url, required this.thumbnails}): super();

  factory ImageMetaDto.fromJson(Map<String, dynamic> json) =>
      _$ImageMetaDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ImageMetaDtoToJson(this);
}
