import 'dart:convert';

import 'package:dating_app/src/domain/dtos/chat/chat_message_dto/chat_message_dto.dart';
import 'package:dating_app/src/domain/dtos/chat/chat_message_dto/message_status_dto.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../core/exception.dart';
import '../../../domain/dtos/chat/list_messages_in_chat/list_messages_in_chat.dart';
import '../../../domain/dtos/response_base/response_base_dto.dart';
import '../../../requests/api_utils.dart';
import '../../../utils/utils.dart';
import '../../remote/api_endpoint.dart';
import '../../remote/api_endpoint/api_end_point_factory.dart';
import '../../remote/middle-handler/error-handler.dart';
import '../base/base_datasource.dart';

@Singleton()
class MessageDataSource extends BaseDatesource {

  Future<ResultAPI<ListMessagesDto>> getMessages(String channelId, int pageSize, int currentPage) async {
    var response = await appClient
        .dioAuth()
        .get(
      ApiEndPointFactory.heartLinkServerEndPoint
          .getChatUrlQueryApi(AppPath.getMessages(channelId, pageSize, currentPage)),
    ).onError((DioException error, stackTrace) =>
        ErrorMiddleHandler.handleDioError(error));
    ErrorMiddleHandler.log(response);

    if (response.statusCode == ApiCode.success && response.data != null) {
      Utils.logger('statusCode: ${response.statusCode}\nbody: ${response.data}');
      return ResultAPI<ListMessagesDto>.fromJson(response.data, (data) => ListMessagesDto.fromJson(data as Map<String, dynamic>));
    }

    throw ServerException();
  }

  Future<bool> updateStatusMessage(UpdateMessageDTO updateMessage) async {
    var response = await appClient
        .dioAuth()
        .post(
      ApiEndPointFactory.heartLinkServerEndPoint
          .getChatUrlQueryApi(AppPath.updateStatusMessage()), data: jsonEncode(updateMessage)
    ).onError((DioException error, stackTrace) =>
        ErrorMiddleHandler.handleDioError(error));
    ErrorMiddleHandler.log(response);

    Utils.logger('statusCode: ${response.statusCode}\nbody: ${response.data}');

    if (response.statusCode == ApiCode.success && response.data != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<ResultAPI<MessageResponseDto>> sendMessage(MessageContent message, String channelId) async {
    var response = await appClient
        .dioAuth()
        .post(
      ApiEndPointFactory.heartLinkServerEndPoint
          .getChatUrlQueryApi(AppPath.addMessage(channelId)),data: jsonEncode(message),
    ).onError((DioException error, stackTrace) =>
        ErrorMiddleHandler.handleDioError(error));
    ErrorMiddleHandler.log(response);

    if (response.statusCode == ApiCode.success && response.data != null) {
      Utils.logger('statusCode: ${response.statusCode}\nbody: ${response.data}');
      return ResultAPI<MessageResponseDto>.fromJson(response.data, (data) => MessageResponseDto.fromJson(data as Map<String, dynamic>));
    }

    throw ServerException();
  }

}