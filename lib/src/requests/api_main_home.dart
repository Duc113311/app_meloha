import 'dart:convert';
import 'package:dating_app/src/domain/dtos/customers/customers_dto.dart';
import 'package:dating_app/src/domain/dtos/home/user_action_response_dto.dart';
import 'package:dating_app/src/domain/dtos/response_base/response_base_dto.dart';
import 'package:http/http.dart' as http;

import '../utils/utils.dart';
import 'api_utils.dart';

class ApiMainHome {
  static List<CustomerDto> listCards = [];

  static Future<int> getBoost() async {
    final url = "${ApiUtils.END_POINT}/api/v1/boost";
    http.Response response = await http.get(
      Uri.parse(url),
      headers: ApiUtils.getHeader(),
    );

    if (response.statusCode != ApiCode.success) {
      Utils.logger('statusCode: ${response.statusCode}\nbody: ${response.body}');
      return response.statusCode;
    }

    Utils.logger('' + '${response.body}');

    return ApiCode.success;
  }

  static Future<int> getListCards() async {
    final url = "${ApiUtils.END_POINT}/api/v1/cards";
    http.Response response = await http.get(
      Uri.parse(url),
      headers: ApiUtils.getHeader(),
    );

    if (response.statusCode != ApiCode.success) {
      Utils.logger('statusCode: ${response.statusCode}\nbody: ${response.body}');
      return response.statusCode;
    }

    final body = json.decode(response.body);
    if (body['data'].length == 0) {
      return ApiCode.dataFormatUnexpected;
    }
    for (int i = 0; i < body['data'].length; i++) {
      CustomerDto? customer = CustomerDto.fromJson(body['data'][i]);
      if (customer == null) continue;
      if (customer.getListAvatarUrls.isEmpty) continue;
      listCards.add(customer);
    }

    return ApiCode.success;
  }

  static Future<int> cardsActionNope(String interactorId) async {
    return await cardsActions('${ApiUtils.END_POINT}/api/v1/nope', interactorId);
  }

  static Future<UserActionResponse?> cardsActionLike(String interactorId, String promptImageId, int type) async {
    return await likeActions('${ApiUtils.END_POINT}/api/v1/like', interactorId, promptImageId, type);
  }

  static Future<int> cardsActionBack(String interactorId) async {
    return await cardsActions('${ApiUtils.END_POINT}/api/v1/back', interactorId);
  }

  static Future<int> cardsActionSuperLike(String interactorId) async {
    return await cardsActions('${ApiUtils.END_POINT}/api/v1/superLike', interactorId);
  }

  static Future<int> cardsActions(String url, String interactorId) async {
    http.Response response = await http.post(
      Uri.parse(url),
      headers: ApiUtils.getHeader(),
      body: jsonEncode({'interactorId': interactorId}),
    );

    if (response.statusCode != ApiCode.success) {
      Utils.logger('statusCode: ${response.statusCode}\nbody: ${response.body}');
      return response.statusCode;
    }

    return ApiCode.success;
  }

  static Future<UserActionResponse?> likeActions(String url, String interactorId, String promptImageId, int type) async {
    http.Response response = await http.post(
      Uri.parse(url),
      headers: ApiUtils.getHeader(),
      body: jsonEncode({'interactorId': interactorId, "promptImageId": promptImageId, "type": type}),
    );

    final body = json.decode(response.body);
    final resultModel = ResultAPI<UserActionResponse>.fromJson(
        body, (data) => UserActionResponse.fromJson(data as Map<String, dynamic>));

    //print(resultModel);
    return resultModel.data;
  }
}
