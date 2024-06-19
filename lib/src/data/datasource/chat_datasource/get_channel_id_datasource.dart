

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../core/exception.dart';
import '../../../domain/dtos/chat/channel/get_channel_id.dart';
import '../../../requests/api_utils.dart';
import '../../../utils/utils.dart';
import '../../remote/api_endpoint.dart';
import '../../remote/api_endpoint/api_end_point_factory.dart';
import '../../remote/middle-handler/error-handler.dart';
import '../base/base_datasource.dart';

@Singleton()
class GetChannelIdDataSource extends BaseDatesource {

  Future<ChannelIdDto> getChannelId(receiverId) async {
    var response = await appClient
        .dioAuth()
        .get(
      ApiEndPointFactory.heartLinkServerEndPoint
          .getChatUrlQueryApi(AppPath.getChannelId(receiverId)),
    ).onError((DioError error, stackTrace) =>
        ErrorMiddleHandler.handleDioError(error));
    ErrorMiddleHandler.log(response);

    if (response.statusCode == ApiCode.success && response.data != null) {
      Utils.logger('statusCode: ${response.statusCode}\nbody: ${response.data}');
      return ChannelIdDto.fromJson(response.data['data']);
    }

    throw ServerException();
  }

}
