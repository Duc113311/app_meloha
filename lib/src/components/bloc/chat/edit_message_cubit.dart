import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/remote/middle-handler/failure.dart';
import '../../../domain/dtos/chat/chat_message_dto/chat_message_dto.dart';
import '../../../domain/repositories/chat_repo/edit_message_repo.dart';
import '../../../general/inject_dependencies/inject_dependencies.dart';

part 'edit_message_state.dart';

class EditMessageCubit extends Cubit<EditMessageState> {
  EditMessageCubit() : super(EditMessageInitial());

  final EditMessageRepo _repo = getIt<EditMessageRepo>();

  Future<void> editMessage(MessageContent message, String channelId) async {
    emit(EditMessageInitial());

    _repo.editMessage(message, channelId).then((value) => value.fold((left) {
      return emit(EditMessageFailed(left));
    }, (right) {
      emit(EditMessageSuccess(right.record));
    },),);
  }
}
