class ServerException implements Exception {
  String? message;
  ServerException({this.message});
}

class NotFoundException implements Exception {
  String? message;
  NotFoundException({this.message});
}

class UnauthorizedException implements Exception {
  String? message;
  UnauthorizedException({this.message});
}

class ForbiddenException implements Exception {
  String? message;
  ForbiddenException({this.message});
}

class RequestException implements Exception {
  String? message;
  RequestException({this.message});
}

class TimeoutException implements Exception {
  String? message;
  TimeoutException({this.message});
}

class NullException implements Exception {}

class InputInvalidException implements Exception {}

class SaveLocalException implements Exception {}

class NotInternetException implements Exception {}
