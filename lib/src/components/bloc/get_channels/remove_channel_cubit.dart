import 'package:bloc/bloc.dart';
import 'package:dating_app/src/domain/dtos/response_base/response_base_dto.dart';
import 'package:dating_app/src/domain/repositories/chat_repo/remove_channel_repo.dart';
import 'package:meta/meta.dart';

import '../../../data/remote/middle-handler/failure.dart';
import '../../../general/inject_dependencies/inject_dependencies.dart';

part 'remove_channel_state.dart';

class RemoveChannelCubit extends Cubit<RemoveChannelState> {
RemoveChannelCubit() : super(RemoveChannelInitial());

  final RemoveChannelRepo _repo = getIt<RemoveChannelRepo>();

  Future<void> removeChannel(String channelId) async {
    _repo.removeChannel(channelId).then((value) => value.fold((left) {
      return emit(RemoveChannelFailed(left));
    }, (right) {
      emit(RemoveChannelSuccess(right));
    },),);
  }
}

