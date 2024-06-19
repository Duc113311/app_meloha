import 'package:bloc/bloc.dart';
import 'package:dating_app/src/domain/dtos/response_base/response_base_dto.dart';
import 'package:dating_app/src/domain/repositories/chat_repo/send_message_repo.dart';
import 'package:meta/meta.dart';

import '../../../data/remote/middle-handler/failure.dart';
import '../../../domain/dtos/chat/chat_message_dto/chat_message_dto.dart';
import '../../../general/inject_dependencies/inject_dependencies.dart';

part 'send_message_state.dart';

class SendMessageCubit extends Cubit<SendMessageState> {
  SendMessageCubit() : super(SendMessageInitial());

  final SendMessageRepo _repo = getIt<SendMessageRepo>();

  Future<void> sendMessage(MessageContent message, String channelId) async {
    _repo.sendMessage(message, channelId).then((value) => value.fold((left) {
      return emit(SendMessageFailed(left));
    }, (right) {
      emit(SendMessageSuccess(right));
    },),);
  }
}
