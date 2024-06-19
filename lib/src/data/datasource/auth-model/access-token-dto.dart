import '../../../core/exception.dart';

class AccessTokenDto {
  String? accessToken;

  AccessTokenDto(String? accessToken) {
    if (accessToken == null || accessToken.isEmpty) {
      throw InputInvalidException();
    }
    this.accessToken = accessToken;
  }
}
