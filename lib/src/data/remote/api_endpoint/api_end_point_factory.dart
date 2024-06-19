library api_endpoint;
import 'package:flutter/material.dart';

import '../../../app_manager.dart';
import '../../../general/app_flavor/app_config.dart';
import '../../../general/constants/app_enum.dart';
import '../api_endpoint.dart';

part './implements_api_endpoint/heartlink_api_end_point.dart';


class ApiEndPointFactory {
  static BuildContext get _context => AppManager.globalKeyRootMaterial.currentContext!;
  static AppEnvironment get _environment => AppConfig.of(_context)?.environment ?? AppEnvironment.DEVELOPMENT;

  /// dev https://mochian-test.akira.edu.vn
  /// production https://mochian3.0-api.mochidemy.com
  static ApiEndpoint get heartLinkServerEndPoint => _HeartLinkApiEndPoint(environment: _environment);


}
