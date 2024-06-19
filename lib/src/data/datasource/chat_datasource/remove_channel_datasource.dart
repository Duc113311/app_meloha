

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../core/exception.dart';
import '../../../domain/dtos/response_base/response_base_dto.dart';
import '../../../requests/api_utils.dart';
import '../../../utils/utils.dart';
import '../../remote/api_endpoint.dart';
import '../../remote/api_endpoint/api_end_point_factory.dart';
import '../../remote/middle-handler/error-handler.dart';
import '../base/base_datasource.dart';

@Singleton()
class RemoveChannelDataSource extends BaseDatesource {

  Future<ResultAPI<AnyJson>> removeChannel(String channelId) async {
    var response = await appClient
        .dioAuth()
        .put(
      ApiEndPointFactory.heartLinkServerEndPoint
          .getChatUrlQueryApi(AppPath.removeChannel(channelId)),
    ).onError((DioError error, stackTrace) =>
        ErrorMiddleHandler.handleDioError(error));
    ErrorMiddleHandler.log(response);

    if (response.statusCode == ApiCode.success && response.data != null) {
      Utils.logger('statusCode: ${response.statusCode}\nbody: ${response.data}');
      return ResultAPI<AnyJson>.fromJson(response.data, (data) => AnyJson());
    }

    throw ServerException();
  }

}
