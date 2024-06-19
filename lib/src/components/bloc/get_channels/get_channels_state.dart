part of 'get_channels_cubit.dart';

@immutable
abstract class GetChannelsState {
  ListChannelsDto? result;
  Failure? failure;

  GetChannelsState({this.result, this.failure});

  setSuccess(ListChannelsDto result) {
    this.result = result;
  }

  setError(Failure failure) {
    this.failure = failure;
  }
}

class GetChannelsInitial extends GetChannelsState {}

class GetChannelsSuccess extends GetChannelsState {
  GetChannelsSuccess(ListChannelsDto result) {
    super.setSuccess(result);
  }
}

class GetChannelsFailed extends GetChannelsState {
  GetChannelsFailed(Failure failure) {
    setError(failure);
  }
}
