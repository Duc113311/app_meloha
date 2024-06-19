import 'package:json_annotation/json_annotation.dart';
import '../../customers/customers_dto.dart';

part 'list_friends_dto.g.dart';

@JsonSerializable()
class ListFriendsDto {
  @JsonKey(name: 'currentPage')
  int currentPage;

  @JsonKey(name: 'skip')
  int skip;

  @JsonKey(name: 'limit')
  int limit;

  @JsonKey(name: 'count')
  int count;

  @JsonKey(name: 'total')
  int total;


  @JsonKey(name: 'list_data')
  List<CustomerDto>? listData;

  ListFriendsDto({
    required this.currentPage,
    required this.skip,
    required this.limit,
    required this.count,
    required this.total,
    required this.listData,
  });

  factory ListFriendsDto.fromJson(Map<String, dynamic> json) =>
      _$ListFriendsDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ListFriendsDtoToJson(this);
}