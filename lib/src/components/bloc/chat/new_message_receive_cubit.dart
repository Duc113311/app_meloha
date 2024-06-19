import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/remote/middle-handler/failure.dart';
import '../../../domain/dtos/chat/chat_message_dto/chat_message_dto.dart';

part 'new_message_receive_state.dart';

class NewMessageCubit extends Cubit<NewMessageState> {
  NewMessageCubit() : super(NewMessageInitial());

  Future<void> receiveMessage(MessageDto message) async {
    NewMessageSuccess(message);
  }
}
