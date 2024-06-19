part of 'get_messages_cubit.dart';

@immutable
abstract class GetMessagesState {
  ResultAPI<ListMessagesDto>? result;
  Failure? failure;

  GetMessagesState({this.result, this.failure});

  setSuccess(ResultAPI<ListMessagesDto> result) {
    this.result = result;
  }

  setError(Failure failure) {
    this.failure = failure;
  }
}

class GetMessagesInitial extends GetMessagesState {}

class GetMessagesSuccess extends GetMessagesState {
  GetMessagesSuccess(ResultAPI<ListMessagesDto> result) {
    super.setSuccess(result);
  }
}

class GetMessagesFailed extends GetMessagesState {
  GetMessagesFailed(Failure failure) {
    setError(failure);
  }
}

class UpdateStatusMessagesInitial extends GetMessagesState {}

class UpdateStatusMessagesSuccess extends GetMessagesState {
  UpdateStatusMessagesSuccess(ResultAPI<dynamic> result);
}

class UpdateStatusMessagesFailed extends GetMessagesState {
  UpdateStatusMessagesFailed(Failure failure) {
    setError(failure);
  }
}
