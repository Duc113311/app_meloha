
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../core/exception.dart';
import '../../../domain/dtos/chat/list_friends_dto/list_friends_dto.dart';
import '../../../requests/api_utils.dart';
import '../../../utils/utils.dart';
import '../../remote/api_endpoint.dart';
import '../../remote/api_endpoint/api_end_point_factory.dart';
import '../../remote/middle-handler/error-handler.dart';
import '../base/base_datasource.dart';

@Singleton()
class GetFriendsDataSource extends BaseDatesource {

  Future<ListFriendsDto> getAllFriends(int pageSize, int currentPage) async {
    var response = await appClient
        .dioAuth()
        .get(
      ApiEndPointFactory.heartLinkServerEndPoint
          .getChatUrlQueryApi(AppPath.getAllFriends(pageSize, currentPage)),
    ).onError((DioError error, stackTrace) =>
        ErrorMiddleHandler.handleDioError(error));
    ErrorMiddleHandler.log(response);

    if (response.statusCode == ApiCode.success && response.data != null) {
      Utils.logger('statusCode: ${response.statusCode}\nbody: ${response.data}');
      return ListFriendsDto.fromJson(response.data['data']);
    }

    throw ServerException();
  }

  Future<ListFriendsDto> getNewFriends(int pageSize, int currentPage) async {
    var response = await appClient
        .dioAuth()
        .get(
      ApiEndPointFactory.heartLinkServerEndPoint
          .getChatUrlQueryApi(AppPath.getNewFriends(pageSize, currentPage)),
    ).onError((DioError error, stackTrace) =>
        ErrorMiddleHandler.handleDioError(error));
    ErrorMiddleHandler.log(response);

    if (response.statusCode == ApiCode.success && response.data != null) {
      Utils.logger('statusCode: ${response.statusCode}\nbody: ${response.data}');
      return ListFriendsDto.fromJson(response.data['data']);
    }

    throw ServerException();
  }

}
