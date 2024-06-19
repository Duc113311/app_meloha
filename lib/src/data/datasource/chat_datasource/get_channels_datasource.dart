
import 'package:dating_app/src/domain/dtos/chat/channel/get_channels_dto.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../core/exception.dart';
import '../../../requests/api_utils.dart';
import '../../../utils/utils.dart';
import '../../remote/api_endpoint.dart';
import '../../remote/api_endpoint/api_end_point_factory.dart';
import '../../remote/middle-handler/error-handler.dart';
import '../base/base_datasource.dart';

@Singleton()
class GetChannelsDataSource extends BaseDatesource {

  Future<ListChannelsDto> getChannels(int pageSize, int currentPage) async {
    var response = await appClient
        .dioAuth()
        .get(
      ApiEndPointFactory.heartLinkServerEndPoint
          .getChatUrlQueryApi(AppPath.getChannels(pageSize, currentPage)),
    ).onError((DioError error, stackTrace) =>
        ErrorMiddleHandler.handleDioError(error));
    ErrorMiddleHandler.log(response);

    if (response.statusCode == ApiCode.success && response.data != null) {
      Utils.logger('statusCode: ${response.statusCode}\nbody: ${response.data}');
      return ListChannelsDto.fromJson(response.data['data']);
    }


    throw ServerException();
  }

}
