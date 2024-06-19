import 'dart:io';

import 'package:dating_app/src/domain/dtos/customers/customers_dto.dart';
import 'package:dating_app/src/domain/dtos/topics/topic_dto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';

import '../../../core/exception.dart';
import '../../remote/api_endpoint.dart';
import '../../remote/api_endpoint/api_end_point_factory.dart';
import '../../remote/middle-handler/error-handler.dart';
import '../base/base_datasource.dart';

@Singleton()
class ExploreDataSource extends BaseDatesource {
  Future<CustomerDto?> joinExplore(String idTopic) async {
    var response = await appClient
        .dioAuth()
        .put(
          ApiEndPointFactory.heartLinkServerEndPoint
              .getUrlQueryApi('${AppPath.joinExplore}/$idTopic'),
        )
        .onError((DioException error, stackTrace) =>
            ErrorMiddleHandler.handleDioError(error));
    ErrorMiddleHandler.log(response);

    if (response.statusCode == HttpStatus.ok && response.data != null) {
      return CustomerDto.fromJson(response.data['data']);
    }

    throw ServerException();
  }

  Future<CustomerDto?> outTopic(String idTopic) async {
    try {
      var response = await appClient
          .dioAuth()
          .post(
        ApiEndPointFactory.heartLinkServerEndPoint
            .getUrlQueryApi(AppPath.outTopic(idTopic)),
      )
          .onError((DioException error, stackTrace) =>
          ErrorMiddleHandler.handleDioError(error));
      ErrorMiddleHandler.log(response);

      if (response.statusCode == HttpStatus.ok && response.data != null) {
        return CustomerDto.fromJson(response.data['data']);
      } else {
        return null;
      }
    } catch (error) {
      debugPrint("outTopic: $error");
      return null;
    }


  }

  Future<List<CustomerDto>?> getTopicCards(
      String idTopic, int pageSize, int currentPage) async {
    var response = await appClient.dioAuth().get(
        ApiEndPointFactory.heartLinkServerEndPoint
            .getUrlQueryApi('${AppPath.getCardExplore}/$idTopic'),
        queryParameters: {
          'pageSize': pageSize,
          'currentPage': currentPage,
        }).onError((DioException error, stackTrace) =>
        ErrorMiddleHandler.handleDioError(error));
    ErrorMiddleHandler.log(response);

    if (response.statusCode == HttpStatus.ok && response.data != null) {
      return CustomersDto.fromJson(response.data).data;
    }

    throw ServerException();
  }

  Future<List<CustomerDto>?> getVerifiedCards(
      int pageSize, int currentPage) async {
    var response = await appClient.dioAuth().get(
        ApiEndPointFactory.heartLinkServerEndPoint
            .getUrlQueryApi(AppPath.getVerifiedCards),
        queryParameters: {
          'pageSize': pageSize,
          'currentPage': currentPage,
        }).onError((DioException error, stackTrace) =>
        ErrorMiddleHandler.handleDioError(error));
    ErrorMiddleHandler.log(response);

    if (response.statusCode == HttpStatus.ok && response.data != null) {
      return CustomersDto.fromJson(response.data).data;
    }

    throw ServerException();
  }

  Future<ListTopicDto> getListTopics() async {
    var response = await appClient
        .dioAuth()
        .get(
          ApiEndPointFactory.heartLinkServerEndPoint
              .getUrlQueryApi(AppPath.getTopics),
        )
        .onError((DioException error, stackTrace) =>
            ErrorMiddleHandler.handleDioError(error));
    ErrorMiddleHandler.log(response);

    if (response.statusCode == HttpStatus.ok && response.data != null) {
      return ListTopicDto.fromJson(response.data);
    }

    throw ServerException();
  }
}
