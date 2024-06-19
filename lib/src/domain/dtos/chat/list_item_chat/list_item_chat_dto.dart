// import 'package:json_annotation/json_annotation.dart';
// part 'list_item_chat_dto.g.dart';
// @JsonSerializable()
// class ListItemChatDto {
//   @JsonKey(name: 'userId')
//   final int? userId;
//   @JsonKey(name: 'name')
//   final String? name;
//   @JsonKey(name: 'message')
//   final String? message;
//   @JsonKey(name: 'avt')
//   final String? avt;
//   @JsonKey(name: 'age')
//   final int? age;
//
//   ListItemChatDto({this.userId, this.age,
//     this.name,
//     this.message,
//     this.avt,
//   }) : super();
//
//   factory ListItemChatDto.fromJson(Map<String, dynamic> json) =>
//       _$ListItemChatDtoFromJson(json);
//
//   @override
//   Map<String, dynamic> toJson() => _$ListItemChatDtoToJson(this);
// }