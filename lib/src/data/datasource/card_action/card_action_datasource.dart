import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';


import '../../../core/exception.dart';
import '../../../domain/dtos/card_action/card_action_dto.dart';
import '../../../requests/api_utils.dart';
import '../../../utils/utils.dart';
import '../../remote/api_endpoint.dart';
import '../../remote/api_endpoint/api_end_point_factory.dart';
import '../../remote/middle-handler/error-handler.dart';
import '../base/base_datasource.dart';

@Singleton()
class CardActionDataSource extends BaseDatesource {

  Future<LikeDto> likeAction(String interactorId) async {
    var response = await appClient
        .dioAuth()
        .post(
      ApiEndPointFactory.heartLinkServerEndPoint
          .getUrlQueryApi(AppPath.like),data: jsonEncode({'interactorId': interactorId}),
    ).onError((DioError error, stackTrace) =>
        ErrorMiddleHandler.handleDioError(error));
    ErrorMiddleHandler.log(response);

    if (response.statusCode == ApiCode.success && response.data != null) {
      Utils.logger('statusCode: ${response.statusCode}\nbody: ${response.data}');
      return LikeDto.fromJson(response.data['data']);
    }

    throw ServerException();
  }

  Future<int> supperLikeAction(String interactorId) async {
    var response = await appClient
        .dioAuth()
        .post(
      ApiEndPointFactory.heartLinkServerEndPoint
          .getUrlQueryApi(AppPath.superLike),data: jsonEncode({'interactorId': interactorId}),
    ).onError((DioError error, stackTrace) =>
        ErrorMiddleHandler.handleDioError(error));
    ErrorMiddleHandler.log(response);

    if (response.statusCode == ApiCode.success && response.data != null) {
      Utils.logger('statusCode: ${response.statusCode}\nbody: ${response.data}');
      return response.statusCode!;
    }

    throw ServerException();
  }
  Future<NopeDto> nopeAction(String interactorId) async {
    var response = await appClient
        .dioAuth()
        .post(
      ApiEndPointFactory.heartLinkServerEndPoint
          .getUrlQueryApi(AppPath.nope),data: jsonEncode({'interactorId': interactorId}),
    ).onError((DioError error, stackTrace) =>
        ErrorMiddleHandler.handleDioError(error));
    ErrorMiddleHandler.log(response);

    if (response.statusCode == ApiCode.success && response.data != null) {
      Utils.logger('statusCode: ${response.statusCode}\nbody: ${response.data}');
      return NopeDto.fromJson(response.data['data']);
    }

    throw ServerException();
  }

  Future<BoostDto?> boostAction() async {
    var response = await appClient
        .dioAuth()
        .post(
      ApiEndPointFactory.heartLinkServerEndPoint
          .getUrlQueryApi(AppPath.boost),data: jsonEncode({'number': 2}),
    ).onError((DioError error, stackTrace) =>
        ErrorMiddleHandler.handleDioError(error));
    ErrorMiddleHandler.log(response);

    if (response.statusCode == ApiCode.success && response.data != null) {
      Utils.logger('statusCode: ${response.statusCode}\nbody: ${response.data}');
      return BoostResponseDto.fromJson(response.data).data;
    }

    throw ServerException();
  }



}


