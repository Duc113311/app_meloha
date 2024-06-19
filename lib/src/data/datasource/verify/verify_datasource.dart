import 'dart:convert';

import 'package:dating_app/src/core/exception.dart';
import 'package:dating_app/src/data/datasource/base/base_datasource.dart';
import 'package:dating_app/src/data/remote/api_endpoint.dart';
import 'package:dating_app/src/data/remote/api_endpoint/api_end_point_factory.dart';
import 'package:dating_app/src/data/remote/middle-handler/error-handler.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../requests/api_utils.dart';
import '../../../utils/utils.dart';

@Singleton()
class VerifyDataSource extends BaseDatesource {

  Future<bool> verifyPhotos(List<String> images) async {
    var response = await appClient
        .dioAuth()
        .post(
      ApiEndPointFactory.heartLinkServerEndPoint
          .getUrlQueryApi(AppPath.verifyUrl),data: jsonEncode({"images": images}),
    ).onError((DioException error, stackTrace) =>
        ErrorMiddleHandler.handleDioError(error));
    ErrorMiddleHandler.log(response);

    if (response.statusCode == ApiCode.success && response.data != null) {
      Utils.logger('statusCode: ${response.statusCode}\nbody: ${response.data}');
      return true;
    }

    throw ServerException();
  }
}