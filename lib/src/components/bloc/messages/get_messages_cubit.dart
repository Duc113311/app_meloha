
import 'package:bloc/bloc.dart';
import 'package:dating_app/src/domain/dtos/chat/list_messages_in_chat/list_messages_in_chat.dart';
import 'package:dating_app/src/domain/dtos/response_base/response_base_dto.dart';
import 'package:meta/meta.dart';
import '../../../data/remote/middle-handler/failure.dart';
import '../../../domain/dtos/chat/chat_message_dto/message_status_dto.dart';
import '../../../domain/repositories/chat_repo/message_repo.dart';
import '../../../general/inject_dependencies/inject_dependencies.dart';

part 'get_messages_state.dart';

class MessagesCubit extends Cubit<GetMessagesState> {
  MessagesCubit() : super(GetMessagesInitial());

  final MessagesRepo _repo = getIt<MessagesRepo>();

  Future<void> getMessages(String channelId, int pageSize, int currentPage) async {
     _repo.getMessages(channelId, pageSize, currentPage).then((value) => value.fold((left) {
      return emit(GetMessagesFailed(left));
    }, (right) {
      emit(GetMessagesSuccess(right));
    },),);
  }

  Future<void> updateStatusMessage(UpdateMessageDTO updateMessage) async {
    _repo.updateStatusMessage(updateMessage).then((value) => value.fold((left) {
      return emit(UpdateStatusMessagesFailed(left));
    }, (right) {
      emit(UpdateStatusMessagesSuccess(right));
    },),);
  }
}
