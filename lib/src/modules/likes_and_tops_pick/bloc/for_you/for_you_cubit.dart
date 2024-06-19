import 'package:bloc/bloc.dart';
import 'package:dating_app/src/domain/services/connect/connectivity_service.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:meta/meta.dart';

import '../../../../data/object_request_api/likes_and_for_you/likes_request.dart';
import '../../../../data/remote/middle-handler/failure.dart';
import '../../../../domain/dtos/like_and_top_pick/customers_like_top_dto.dart';
import '../../../../domain/repositories/like_and_for_you/like_an_for_you_repo.dart';
import '../../../../general/inject_dependencies/inject_dependencies.dart';

part 'for_you_state.dart';

class ForYouCubit extends Cubit<ForYouState> {
  ForYouCubit() : super(ForYouInitial()){
    getForYou();
  }
  LikeAndForYouRepo likeAndForYouRepo = getIt<LikeAndForYouRepo>();

  LikesRequest likesRequest = LikesRequest(
      -1,0,'like'
  );

  Future<void> getForYou()async {
    emit(ForYouLoading());
    //check network
    bool checkConnect = await ConnectivityService.canConnectToNetwork();
    if (checkConnect == false) {
      Utils.internetError();
      return;
    }
    likeAndForYouRepo.getForYou(likesRequest).then((value) => value.fold((left) {
      return emit(ForYouFailed(left));
    }, (right) {
      emit(ForYouSuccess(state)..list = right.listData);
    }));
  }
  Future<void> removeItem(int index)async {
    final newList = List.of(state.list!)..removeAt(index);
    final newState = (ForYouRemoveItem(state)..list = newList);
    emit(newState);
  }
}
