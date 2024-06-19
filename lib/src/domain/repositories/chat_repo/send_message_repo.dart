
import 'package:dating_app/src/domain/dtos/chat/chat_message_dto/chat_message_dto.dart';
import 'package:dating_app/src/domain/dtos/response_base/response_base_dto.dart';
import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import '../../../data/datasource/chat_datasource/send_message_datasource.dart';
import '../../../data/remote/middle-handler/failure.dart';
import '../../../data/remote/middle-handler/result-handler.dart';
import '../../../general/inject_dependencies/inject_dependencies.dart';

@Singleton()
class SendMessageRepo {
  SendMessageDataSource get sendMessageDataSource => getIt<SendMessageDataSource>();

  Future<Either<Failure, ResultAPI<MessageResponseDto>>> sendMessage(MessageContent message, String channelId) async {
    return ResultMiddleHandler.checkResult(() async {
      return await sendMessageDataSource.sendMessage(message, channelId);
    });
  }

}
