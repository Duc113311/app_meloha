import 'package:json_annotation/json_annotation.dart';

part 'report_dto.g.dart';

@JsonSerializable()
class ReasonDto {
  @JsonKey(name: 'count')
  final int count;
  @JsonKey(name: 'data')
  final List<ReasonsDto> reports;

  ReasonDto({
    required this.count,
    required this.reports,
  }) : super();

  factory ReasonDto.fromJson(Map<String, dynamic> json) =>
      _$ReasonDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ReasonDtoToJson(this);
}

@JsonSerializable()
class ReasonsDto {
  @JsonKey(name: '_id')
  final String id;
  @JsonKey(name: 'reason')
  final String reason;
  @JsonKey(name: 'details')
  final List<String> details;

  ReasonsDto({
    required this.id,
    required this.reason,
    required this.details,
  }) : super();

  factory ReasonsDto.fromJson(Map<String, dynamic> json) =>
      _$ReasonsDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ReasonsDtoToJson(this);
}

@JsonSerializable()
class ReportDto {
  @JsonKey(name: 'userId')
  final String? userId;
  @JsonKey(name: 'reasonId')
  final String? reasonId;
  @JsonKey(name: 'reasonDetail')
  final String? reasonDetail;
  @JsonKey(name: 'comments')
  final String? comments;

  ReportDto({
    this.userId,
    this.reasonId,
    this.reasonDetail,
    this.comments,
  }) : super();

  ReportDto copyWith({
    String? userId,
    String? reasonId,
    String? reasonDetail,
    String? comments,
  }) =>
      ReportDto(
        userId: userId ?? this.userId,
        reasonId: reasonId ?? this.reasonId,
          reasonDetail: reasonDetail ?? this.reasonDetail,
          comments: comments ?? this.comments,
      );

  factory ReportDto.fromJson(Map<String, dynamic> json) =>
      _$ReportDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ReportDtoToJson(this);
}
