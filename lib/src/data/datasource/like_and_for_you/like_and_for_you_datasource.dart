import 'dart:io';

import 'package:dating_app/src/domain/dtos/like_and_top_pick/customers_like_top_dto.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../core/exception.dart';
import '../../object_request_api/likes_and_for_you/likes_request.dart';
import '../../remote/api_endpoint.dart';
import '../../remote/api_endpoint/api_end_point_factory.dart';
import '../../remote/middle-handler/error-handler.dart';
import '../base/base_datasource.dart';

@Singleton()
class LikeAndForYouDataSource extends BaseDatesource {
  Future<LikeTopDto> getLikes(LikesRequest likesRequest) async {
    var response = await appClient.dioAuth().get(ApiEndPointFactory.heartLinkServerEndPoint.getUrlQueryApi(AppPath.likes), queryParameters: likesRequest.toJson()).onError((DioError error, stackTrace) => ErrorMiddleHandler.handleDioError(error));
    ErrorMiddleHandler.log(response);

    if (response.statusCode == HttpStatus.ok && response.data != null) {
      return LikeTopDto.fromJson(response.data['data']);
    }

    throw ServerException();
  }
  Future<LikeTopDto> getForYou(LikesRequest likesRequest) async {
    var response = await appClient.dioAuth().get(ApiEndPointFactory.heartLinkServerEndPoint.getUrlQueryApi(AppPath.forYou), queryParameters: likesRequest.toJson()).onError((DioError error, stackTrace) => ErrorMiddleHandler.handleDioError(error));
    ErrorMiddleHandler.log(response);

    if (response.statusCode == HttpStatus.ok && response.data != null) {
      return LikeTopDto.fromJson(response.data['data']);
    }

    throw ServerException();
  }
}
