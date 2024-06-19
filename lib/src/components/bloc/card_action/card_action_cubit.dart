import 'package:bloc/bloc.dart';
import 'package:dating_app/src/domain/dtos/card_action/card_action_dto.dart';
import 'package:meta/meta.dart';

import '../../../data/remote/middle-handler/failure.dart';
import '../../../domain/dtos/customers/customers_dto.dart';
import '../../../domain/repositories/card_action/card_action_repo.dart';
import '../../../general/inject_dependencies/inject_dependencies.dart';
import '../../../requests/api_utils.dart';

part 'card_action_state.dart';

class CardActionCubit extends Cubit<CardActionState> {
  CardActionCubit() : super(CardActionInitial());
  final CardActionRepo _repo = getIt<CardActionRepo>();

  Future<void> likeAction(CustomerDto customer, int index) async {
    _repo.likeAction(customer.id!).then(
          (value) => value.fold(
            (left) {
              return emit(CardActionFailed(left));
            },
            (right) {
              if (right.isMatched == false) {
                emit(CardActionSuccess(state));
              } else {
                emit(CardActionMatch(customer, index));
              }
            },
          ),
        );
  }

  Future<void> supperLikeAction(String interactorId) async {
    _repo.supperLikeAction(interactorId).then(
          (value) => value.fold(
            (left) {
              return emit(CardActionFailed(left));
            },
            (right) {
              if (ApiCode.success == right) {
                emit(CardActionSuccess(state));
              }
            },
          ),
        );
  }

  Future<void> nopeAction(String interactorId) async {
    _repo.nopeAction(interactorId).then(
          (value) => value.fold(
            (left) {
              return emit(CardActionFailed(left));
            },
            (right) {
              if (ApiCode.success == right) {
                emit(CardActionSuccess(state));
              }
            },
          ),
        );
  }

  Future<void> boostAction() async {
    _repo.boostAction().then((value) => value.fold((left) {
          return emit(CardActionFailed(left));
        }, (right) {
          emit(CardActionBoostSuccess(state)..boostDto = right);
        }));
  }
}
