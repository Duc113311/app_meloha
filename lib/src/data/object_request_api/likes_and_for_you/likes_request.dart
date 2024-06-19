
import 'package:json_annotation/json_annotation.dart';

part 'likes_request.g.dart';

@JsonSerializable()
class LikesRequest {
  @JsonKey(name: 'pageSize')
  final int pageSize;//lấy về bao nhiêu bản ghi mỗi lần
  @JsonKey(name: 'currentPage')
  final int currentPage;//lấy page bao nhiêu
  @JsonKey(name: 'action',defaultValue: 'like')
  final String action;

  LikesRequest(this.pageSize, this.currentPage, this.action);

  @override
  Map<String, dynamic> toJson() => _$LikesRequestToJson(this);
}






@JsonSerializable()
class ForYouRequest {
  @JsonKey(name: 'pageSize')
  final int pageSize;//lấy về bao nhiêu bản ghi mỗi lần


  ForYouRequest(this.pageSize);

  @override
  Map<String, dynamic> toJson() => _$ForYouRequestToJson(this);
}