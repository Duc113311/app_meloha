part of api_endpoint;


class _HeartLinkApiEndPoint extends ApiEndpoint{
  _HeartLinkApiEndPoint({required super.environment});

  @override
  String  baseUrl() {
    switch(environment){
      case AppEnvironment.DEVELOPMENT:
        return 'https://api.heartlinkdating.com';
      case AppEnvironment.PRODUCTION:
        return 'https://api.heartlinkdating.com';
    }
  }

  @override
  String chatHost() {
    return "https://chat.heartlinkdating.com";
  }

}