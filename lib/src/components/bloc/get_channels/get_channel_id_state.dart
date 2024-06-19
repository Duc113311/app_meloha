part of 'get_channel_id_cubit.dart';


@immutable
abstract class GetChannelIdState {
  ChannelIdDto? result;
  Failure? failure;

  GetChannelIdState({this.result, this.failure});

  setSuccess(ChannelIdDto result) {
    this.result = result;
  }

  setError(Failure failure) {
    this.failure = failure;
  }
}

class GetChannelIdInitial extends GetChannelIdState {}

class GetChannelIdSuccess extends GetChannelIdState {
  GetChannelIdSuccess(ChannelIdDto result) {
    super.setSuccess(result);
  }
}

class GetChannelIdFailed extends GetChannelIdState {
  GetChannelIdFailed(Failure failure) {
    setError(failure);
  }
}
