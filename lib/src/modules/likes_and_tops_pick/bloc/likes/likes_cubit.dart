import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../data/object_request_api/likes_and_for_you/likes_request.dart';
import '../../../../data/remote/middle-handler/failure.dart';
import '../../../../domain/dtos/like_and_top_pick/customers_like_top_dto.dart';
import '../../../../domain/repositories/card_action/card_action_repo.dart';
import '../../../../domain/repositories/like_and_for_you/like_an_for_you_repo.dart';
import '../../../../general/inject_dependencies/inject_dependencies.dart';

part 'likes_state.dart';

class LikesCubit extends Cubit<LikesState> {
  LikesCubit() : super(LikesInitial());

  final CardActionRepo _cardActionRepo = getIt<CardActionRepo>();
  LikeAndForYouRepo _likeAndForYouRepo = getIt<LikeAndForYouRepo>();

  LikesRequest likesRequest = LikesRequest(-1, 0, 'like');

  Future<void> getLikes() async {
    emit(LikesLoading());
    _likeAndForYouRepo.getLikes(likesRequest).then(
          (value) => value.fold(
            (left) {
              return emit(LikesFailed(left));
            },
            (right) {
              //convertHash(right.listData!);
              emit(LikesSuccess(right.listData));
            },
          ),
        );
  }

  Future<void> likeAction(String interactorId) async {
    await _cardActionRepo.likeAction(interactorId);
  }

  Future<void> supperLikeAction(String interactorId) async {
    _cardActionRepo.supperLikeAction(interactorId);
  }

  Future<void> nopeAction(String interactorId) async {
    _cardActionRepo.nopeAction(interactorId);
  }

  Future<void> boostAction() async {
    _cardActionRepo.boostAction();
  }
}
