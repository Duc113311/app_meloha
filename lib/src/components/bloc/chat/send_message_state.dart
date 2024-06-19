part of 'send_message_cubit.dart';

@immutable
abstract class SendMessageState {
  ResultAPI<MessageResponseDto>? result;
  Failure? failure;

  SendMessageState({this.result, this.failure});

  setSuccess(ResultAPI<MessageResponseDto> result) {
    this.result = result;
  }

  setError(Failure failure) {
    this.failure = failure;
  }
}

class SendMessageInitial extends SendMessageState {}

class SendMessageSuccess extends SendMessageState {
  SendMessageSuccess(ResultAPI<MessageResponseDto> result) {
    super.setSuccess(result);
  }
}

class SendMessageFailed extends SendMessageState {
  SendMessageFailed(Failure failure) {
    setError(failure);
  }
}

