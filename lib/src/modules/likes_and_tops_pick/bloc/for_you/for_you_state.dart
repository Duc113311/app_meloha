part of 'for_you_cubit.dart';

@immutable
abstract class ForYouState {String? errorMessage;
List<CustomersLikeTopDto>? list;

copy(ForYouState state) {
  this.list = state.list ?? <CustomersLikeTopDto>[];
}

setError(String? errorMessage) {
  this.errorMessage = errorMessage;
}
}

class ForYouInitial extends ForYouState {}
class ForYouLoading extends ForYouState {}
class ForYouNotInternet extends ForYouState {}
class ForYouSuccess extends ForYouState {
  ForYouSuccess(ForYouState state) {
    super.copy(state);
  }
}
class ForYouRemoveItem extends ForYouSuccess {
  ForYouRemoveItem(super.state);
}
class ForYouFailed extends ForYouState {
  ForYouFailed(Failure failure) {
    setError(failure.message);
  }
}
