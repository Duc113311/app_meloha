import 'package:flutter/cupertino.dart';
import '../../../app_manager.dart';
import '../../../core/exception.dart';
import '../../../general/inject_dependencies/inject_dependencies.dart';
import '../../../utils/pref_assist.dart';
import '../../remote/app-client.dart';
import '../auth-model/access-token-dto.dart';


abstract class BaseDatesource {
  AppClient get appClient => getIt<AppClient>();
  BuildContext get context => AppManager.globalKeyRootMaterial.currentContext!;


  AccessTokenDto getLocalAccessToken() {
    var accessToken = PrefAssist.getAccessToken();
    if (accessToken == null) {
      throw NullException();
    }
    return AccessTokenDto(accessToken);
  }
}