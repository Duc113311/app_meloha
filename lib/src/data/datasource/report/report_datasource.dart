import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';


import '../../../core/exception.dart';
import '../../../domain/dtos/report/report_dto.dart';
import '../../remote/api_endpoint.dart';
import '../../remote/api_endpoint/api_end_point_factory.dart';
import '../../remote/middle-handler/error-handler.dart';
import '../base/base_datasource.dart';

@Singleton()
class ReportDataSource extends BaseDatesource {
  Future<ReasonDto> getReason() async {
    var response = await appClient
        .dioAuth()
        .get(
      ApiEndPointFactory.heartLinkServerEndPoint
          .getUrlQueryApi(AppPath.reasons)
    ).onError((DioError error, stackTrace) =>
        ErrorMiddleHandler.handleDioError(error));
    ErrorMiddleHandler.log(response);

    if (response.statusCode == HttpStatus.ok && response.data != null) {
      return ReasonDto.fromJson(response.data) ;
    }

    throw ServerException();
  }

  Future<ReportDto> report(ReportDto reportDto) async {
    var response = await appClient
        .dioAuth()
        .post(
        ApiEndPointFactory.heartLinkServerEndPoint
            .getUrlQueryApi(AppPath.report),data: reportDto.toJson()
    ).onError((DioException error, stackTrace) =>
        ErrorMiddleHandler.handleDioError(error));
    ErrorMiddleHandler.log(response);

    if (response.statusCode == HttpStatus.ok && response.data != null) {
      return ReportDto.fromJson(response.data['data']) ;
    }

    throw ServerException();
  }

}
