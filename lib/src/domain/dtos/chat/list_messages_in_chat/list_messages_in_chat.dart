
import 'package:json_annotation/json_annotation.dart';
import '../../customers/customers_dto.dart';
import '../chat_message_dto/chat_message_dto.dart';
part 'list_messages_in_chat.g.dart';

@JsonSerializable()
class ListMessagesDto {
  @JsonKey(name: 'channelId')
  String channelId;

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
  List<MessageDto>? listData;

  @JsonKey(name: 'clients')
  List<CustomerDto> clients;

  ListMessagesDto({
    required this.channelId,
    required this.currentPage,
    required this.skip,
    required this.limit,
    required this.count,
    required this.total,
    required this.listData,
    required this.clients,
  });

  factory ListMessagesDto.fromJson(Map<String, dynamic> json) =>
      _$ListMessagesDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ListMessagesDtoToJson(this);
}
