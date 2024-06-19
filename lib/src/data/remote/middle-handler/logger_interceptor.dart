import 'package:dating_app/src/data/remote/curl.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
CancelToken cancelTokenMiddleware = CancelToken();

class LoggerInterceptor extends Interceptor{
 static String? requestOptionsError;
 static Response? responseError;
 static DateTime? timeResponse;
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    Logger logger = Logger(level: Level.verbose);
    options.cancelToken = cancelTokenMiddleware;
    logger.i(options.toCurl());
    super.onRequest(options, handler);
  }
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    Logger logger = Logger(level: Level.warning);
    logger.w(response.data);
    super.onResponse(response, handler);
  }
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if(err.response?.statusCode != 200){
      requestOptionsError = err.requestOptions.toCurl();
      responseError = err.response;
      timeResponse = DateTime.now();
    }
    super.onError(err, handler);
  }
}