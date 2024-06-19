
import 'package:dating_app/src/data/datasource/chat_datasource/edit_message_datasource.dart';
import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';

import '../../../data/remote/middle-handler/failure.dart';
import '../../../data/remote/middle-handler/result-handler.dart';
import '../../../general/inject_dependencies/inject_dependencies.dart';
import '../../dtos/chat/chat_message_dto/chat_message_dto.dart';

@Singleton()
class EditMessageRepo {
  EditMessageDataSource get sendMessageDataSource => getIt<EditMessageDataSource>();

  Future<Either<Failure, MessageResponseDto>> editMessage(MessageContent message, String channelId) async {
    return ResultMiddleHandler.checkResult(() async {
      return await sendMessageDataSource.editMessage(message, channelId);
    });
  }

}
