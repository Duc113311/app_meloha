part of 'new_message_receive_cubit.dart';

@immutable
abstract class NewMessageState {
  MessageDto? message;
  Failure? failure;

  NewMessageState({this.message, this.failure});

  setSuccess(MessageDto message) {
    this.message = message;
  }

  setError(Failure failure) {
    this.failure = failure;
  }
}

class NewMessageInitial extends NewMessageState {}

class NewMessageSuccess extends NewMessageState {
  NewMessageSuccess(MessageDto message) {
    super.setSuccess(message);
  }
}

class NewMessageFailed extends NewMessageState {
  NewMessageFailed(Failure failure) {
    setError(failure);
  }
}

