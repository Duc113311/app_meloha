part of 'edit_message_cubit.dart';

@immutable
abstract class EditMessageState {
  MessageDto? message;
  Failure? failure;

  EditMessageState({this.message, this.failure});

  setSuccess(MessageDto message) {
    this.message = message;
  }

  setError(Failure failure) {
    this.failure = failure;
  }
}

class EditMessageInitial extends EditMessageState {}

class EditMessageSuccess extends EditMessageState {
  EditMessageSuccess(MessageDto message) {
    super.setSuccess(message);
  }
}

class EditMessageFailed extends EditMessageState {
  EditMessageFailed(Failure failure) {
    setError(failure);
  }
}

