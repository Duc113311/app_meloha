import 'dart:io';

import 'package:dating_app/src/requests/api_utils.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../core/exception.dart';
import '../../remote/api_endpoint.dart';
import '../../remote/api_endpoint/api_end_point_factory.dart';
import '../../remote/middle-handler/error-handler.dart';
import '../base/base_datasource.dart';

@Singleton()
class DeletedAccountDataSource extends BaseDatesource {
  Future<bool> deleted() async {
    var response = await appClient.dioAuth().delete(ApiEndPointFactory.heartLinkServerEndPoint.getUrlQueryApi(AppPath.deletedAccount),).onError((DioError error, stackTrace) => ErrorMiddleHandler.handleDioError(error));
    ErrorMiddleHandler.log(response);

    if (response.statusCode == HttpStatus.ok && response.data != null) {
      return response.statusCode == ApiCode.success;
    }

    throw ServerException();
  }
}
