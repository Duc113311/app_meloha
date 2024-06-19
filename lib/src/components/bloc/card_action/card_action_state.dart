part of 'card_action_cubit.dart';

@immutable
abstract class CardActionState {

  CardActionState({
    this.boostDto,
  });

  BoostDto? boostDto;
  String? errorMessage;
  CustomerDto? matchUser;
  int imgIndex = 0;

  copy(CardActionState state) {
    boostDto = state.boostDto;
  }

  setError(String? errorMessage) {
    this.errorMessage = errorMessage;
  }

  setMatch(CustomerDto customer, int imgIndex) {
    matchUser = customer;
    this.imgIndex = imgIndex;
  }
}

class CardActionInitial extends CardActionState {}
class CardActionSuccess extends CardActionState {
  CardActionSuccess(CardActionState state) {
    super.copy(state);
  }
}
class CardActionBoostSuccess extends CardActionState {
  CardActionBoostSuccess(CardActionState state) {
    super.copy(state);
  }
}
class CardActionMatch extends CardActionState {
  CardActionMatch(CustomerDto customer, int index) {
    setMatch(customer, index);
  }
}


class CardActionFailed extends CardActionState {
  CardActionFailed(Failure failure) {
    setError(failure.message);
  }
}
