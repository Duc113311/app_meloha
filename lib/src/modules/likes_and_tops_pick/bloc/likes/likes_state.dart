part of 'likes_cubit.dart';

@immutable
abstract class LikesState {
  String? errorMessage;
  List<CustomersLikeTopDto>? customerLikes;

  setSuccess(List<CustomersLikeTopDto> values) {
    customerLikes = values;
  }

  setError(String? errorMessage) {
    this.errorMessage = errorMessage;
  }
}

class LikesInitial extends LikesState {}

class LikesLoading extends LikesState {}

class LikesSuccess extends LikesState {
  LikesSuccess(List<CustomersLikeTopDto>? values) {
    setSuccess(values ?? []);
  }
}

class LikesFailed extends LikesState {
  LikesFailed(Failure failure) {
    setError(failure.message);
  }
}
