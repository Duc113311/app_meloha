import 'package:bloc/bloc.dart';
import 'package:dating_app/src/domain/dtos/chat/channel/get_channel_id.dart';
import 'package:dating_app/src/domain/repositories/chat_repo/get_channel_id_repo.dart';
import 'package:meta/meta.dart';
import '../../../data/remote/middle-handler/failure.dart';
import '../../../general/inject_dependencies/inject_dependencies.dart';

part 'get_channel_id_state.dart';


class GetChannelIdCubit extends Cubit<GetChannelIdState> {
  GetChannelIdCubit() : super(GetChannelIdInitial());

  final GetChannelIdRepo _repo = getIt<GetChannelIdRepo>();

  Future<void> getChannelId(receiverId) async {
    _repo.getChannelId(receiverId).then((value) => value.fold((left) {
      return emit(GetChannelIdFailed(left));
    }, (right) {
      emit(GetChannelIdSuccess(right));
    },),);
  }
}

