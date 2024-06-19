import 'package:bloc/bloc.dart';
import 'package:dating_app/src/domain/dtos/chat/channel/get_channels_dto.dart';
import 'package:dating_app/src/domain/repositories/chat_repo/get_channels_repo.dart';
import 'package:meta/meta.dart';
import '../../../data/remote/middle-handler/failure.dart';
import '../../../general/inject_dependencies/inject_dependencies.dart';

part 'get_channels_state.dart';

class GetChannelsCubit extends Cubit<GetChannelsState> {
  GetChannelsCubit() : super(GetChannelsInitial());

  final GetChannelsRepo _repo = getIt<GetChannelsRepo>();

  Future<void> getChannels(int pageSize, int currentPage) async {
    _repo.getChannels(pageSize, currentPage).then((value) => value.fold((left) {
      return emit(GetChannelsFailed(left));
    }, (right) {
      emit(GetChannelsSuccess(right));
    },),);
  }
}

