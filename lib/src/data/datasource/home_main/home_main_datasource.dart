import 'dart:convert';
import 'dart:io';

import 'package:dating_app/src/general/constants/app_constants.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../core/exception.dart';
import '../../../domain/dtos/customers/customers_dto.dart';
import '../../remote/api_endpoint.dart';
import '../../remote/api_endpoint/api_end_point_factory.dart';
import '../../remote/middle-handler/error-handler.dart';
import '../base/base_datasource.dart';

@Singleton()
class HomeMainDataSource extends BaseDatesource {
  Future<CustomersDto> getListCards() async {
    var response = await appClient.dioAuth().get(
        ApiEndPointFactory.heartLinkServerEndPoint
            .getUrlQueryApi(AppPath.cards),
        queryParameters: {
          'pageSize': AppConstants.limitCard
        }).onError((DioException error, stackTrace) {
      return ErrorMiddleHandler.handleDioError(error);
    });
    ErrorMiddleHandler.log(response);

    if (response.statusCode == HttpStatus.ok && response.data != null) {
      return CustomersDto.fromJson(response.data);
    }

    throw ServerException();
  }
}
