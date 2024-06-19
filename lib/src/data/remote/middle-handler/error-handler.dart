import 'package:dio/dio.dart' as dio;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../../../core/exception.dart';
import '../../../domain/dtos/meta/base_dto.dart';
import '../../../utils/utils.dart';

abstract class ErrorMiddleHandler {
  static handleDioError(dio.DioException error, {StackTrace? stackTrace}) async{
    if (kDebugMode) {
      print(stackTrace);
    }
    _log(error);
    final internet = await Utils.checkConnectionInternet();
    debugPrint('internet: $internet');
    if (!internet) {
      // Utils.showToast('Vui lòng kiểm tra kết nối mạng!');
      NotInternetException();
    }
    if (error.response == null) {
      debugPrint('response is nul');
      throw ServerException(message: 'Server Error');
    }
    switch (error.response!.statusCode) {
      case 400:
        {
          throw RequestException(message: BaseDto.fromJson(error.response!.data).message);
        }
      case 401:
        {
          throw UnauthorizedException(message: BaseDto.fromJson(error.response!.data).message);
        }
      case 403:
      case 404:
        {
          throw NotFoundException(message: BaseDto.fromJson(error.response!.data).message);
        }
      case 408:
        {
          throw TimeoutException(message: BaseDto.fromJson(error.response!.data).message);
        }
      case 500:
        {
          throw ServerException(message: BaseDto.fromJson(error.response!.data).message);
        }
    }
    throw ServerException(message: BaseDto.fromJson(error.response!.data).message);
  }

  static _log(dio.DioException exception) {
    debugPrint('-E-------------');
    debugPrint(exception.requestOptions.uri.toString());
    debugPrint(exception.requestOptions.requestEncoder.toString());
    debugPrint(exception.requestOptions.data);
    debugPrint(exception.requestOptions.headers['authorization']);
    debugPrint(exception.message);
    debugPrint(exception.response?.toString());
    debugPrint('---------------');
  }

  static log(dio.Response<dynamic> res) {
    debugPrint('-R-------------');
    debugPrint(res.requestOptions.sendTimeout.toString());
    debugPrint(res.requestOptions.uri.toString());
    debugPrint(res.requestOptions.data);
    debugPrint(res.requestOptions.headers['authorization']);
    debugPrint(res.data.toString());
    debugPrint(res.statusCode.toString());
    debugPrint('---------------');
  }
}
