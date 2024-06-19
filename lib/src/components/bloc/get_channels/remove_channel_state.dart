part of 'remove_channel_cubit.dart';

@immutable
abstract class RemoveChannelState {
  ResultAPI? result;
  Failure? failure;

  RemoveChannelState({this.result, this.failure});

  setSuccess(ResultAPI result) {
    this.result = result;
  }

  setError(Failure failure) {
    this.failure = failure;
  }
}

class RemoveChannelInitial extends RemoveChannelState {}

class RemoveChannelSuccess extends RemoveChannelState {
  RemoveChannelSuccess(ResultAPI result) {
    super.setSuccess(result);
  }
}

class RemoveChannelFailed extends RemoveChannelState {
  RemoveChannelFailed(Failure failure) {
    setError(failure);
  }
}
