
import 'package:dating_app/src/domain/dtos/chat/chat_message_dto/message_status_dto.dart';
import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';

import '../../../data/datasource/chat_datasource/message_datasource.dart';
import '../../../data/remote/middle-handler/failure.dart';
import '../../../data/remote/middle-handler/result-handler.dart';
import '../../../general/inject_dependencies/inject_dependencies.dart';
import '../../dtos/chat/list_messages_in_chat/list_messages_in_chat.dart';
import '../../dtos/response_base/response_base_dto.dart';

@Singleton()
class MessagesRepo {
  MessageDataSource get getMessagesDataSource => getIt<MessageDataSource>();

  Future<Either<Failure, ResultAPI<ListMessagesDto>>> getMessages(String channelId, int pageSize, int currentPage) async {
    return ResultMiddleHandler.checkResult(() async {
      return await getMessagesDataSource.getMessages(channelId, pageSize, currentPage);
    });
  }

  Future<Either<Failure, ResultAPI<dynamic>>> updateStatusMessage(UpdateMessageDTO updateMessage) async {
    return ResultMiddleHandler.checkResult(() async {
      return await getMessagesDataSource.updateStatusMessage(updateMessage);
    });
  }

}