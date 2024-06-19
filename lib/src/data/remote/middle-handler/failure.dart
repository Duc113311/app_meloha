import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  Failure({this.message = 'Error'});

  String? message;

  @override
  List<Object> get props => [];
}

/// The error default, to show dialog error system
/// When call API from server then only handle Exception extract this.
/// It handle for status 4xx,20x(x not zero),5xx, 3xx...
abstract class FailureDefault extends Failure{}

// General failures
class ServerFailure extends FailureDefault {
  ServerFailure(String? message) {
    this.message = message;
  }
}

class NotFoundFailure extends FailureDefault {
  NotFoundFailure(String? message) {
    this.message = message;
  }
}

class UnauthorizedFailure extends FailureDefault {
  UnauthorizedFailure(String? message) {
    this.message = message;
  }
}

class ForbiddenFailure extends FailureDefault {
  ForbiddenFailure(String? message) {
    this.message = message;
  }
}

class RequestFailure extends FailureDefault {
  RequestFailure(String? message) {
    this.message = message;
  }
}

class TimeoutFailure extends FailureDefault {
  TimeoutFailure(String? message) {
    this.message = message;
  }
}

abstract class ErrorStatusFromServerWithStatus200 extends Failure{
  ErrorStatusFromServerWithStatus200({this.message = 'Error'});


   @override
  String? message;

  @override
  List<Object> get props => [];
}

class SaveLocalFailure extends ErrorStatusFromServerWithStatus200 {}

class DeleteLocalFailure extends ErrorStatusFromServerWithStatus200 {}

class LoadLocalFailure extends ErrorStatusFromServerWithStatus200 {}

class AccessFailure extends ErrorStatusFromServerWithStatus200 {}

class UserFailure {
  UserFailure.fromServer();
  UserFailure({this.message});
  String? message;
}
