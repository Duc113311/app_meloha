import 'package:dating_app/src/requests/api_utils.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'insert_dto.g.dart';

@JsonSerializable()
class InsertDto {

  @JsonKey(name: 'when')
  int when;

  @JsonKey(name: 'by')
  String? by;

  DateTime get date {
    return DateTime.fromMillisecondsSinceEpoch(when);
  }

  InsertDto({
    required this.when, this.by
  }) : super();

  factory InsertDto.fromJson(Map<String, dynamic> json) =>
      _$InsertDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$InsertDtoToJson(this);
}

@JsonSerializable()
class ChatInsertDto {

  DateTime get date {
    DateTime parseDate =
    DateFormat(ApiUtils.DATE_TIME_FORMAT).parse(when);
    final date = DateTime.parse(parseDate.toString());
    return date;
  }

  @JsonKey(name: 'when')
  String when;

  ChatInsertDto({
    required this.when
  }) : super();

  factory ChatInsertDto.fromJson(Map<String, dynamic> json) =>
      _$ChatInsertDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ChatInsertDtoToJson(this);
}