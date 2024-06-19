

import 'dart:convert';

import 'package:dating_app/src/domain/dtos/chat/chat_message_dto/chat_message_dto.dart';
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
class SendMessageDataSource extends BaseDatesource {

  Future<ResultAPI<MessageResponseDto>> sendMessage(MessageContent message, String channelId) async {
    var response = await appClient
        .dioAuth()
        .post(
      ApiEndPointFactory.heartLinkServerEndPoint
          .getChatUrlQueryApi(AppPath.addMessage(channelId)),data: jsonEncode(message),
    ).onError((DioError error, stackTrace) =>
        ErrorMiddleHandler.handleDioError(error));
    ErrorMiddleHandler.log(response);

    if (response.statusCode == ApiCode.success && response.data != null) {
      Utils.logger('statusCode: ${response.statusCode}\nbody: ${response.data}');
      return ResultAPI<MessageResponseDto>.fromJson(response.data, (data) => MessageResponseDto.fromJson(data as Map<String, dynamic>));
    }

    throw ServerException();
  }

}
