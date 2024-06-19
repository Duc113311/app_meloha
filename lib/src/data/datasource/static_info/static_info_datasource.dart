import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';

import '../../../core/exception.dart';
import '../../../data/datasource/base/base_datasource.dart';
import '../../../data/remote/api_endpoint.dart';
import '../../../data/remote/api_endpoint/api_end_point_factory.dart';
import '../../../data/remote/middle-handler/error-handler.dart';
import '../../../requests/api_utils.dart';

@Singleton()
class StaticInfoDataSource extends BaseDatesource {
  Future<T?> requestStaticInfo<T>(String path) async {
    try {
      var response = await appClient
          .dioAuth()
          .get(ApiEndPointFactory.heartLinkServerEndPoint.getUrlQueryApi(path))
          .onError((DioException error, stackTrace) {
        return ErrorMiddleHandler.handleDioError(error);
      });

      ErrorMiddleHandler.log(response);

      if (response.statusCode == ApiCode.success && response.data != null) {
        return response.data['data'];
      } else {
        return null;
      }
    } catch (error) {
      debugPrint("requestStaticInfo: $error");
      return null;
    }
  }
}
