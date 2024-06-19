import 'dart:convert';
import 'package:dating_app/src/components/bloc/static_info/static_info_data.dart';
import 'package:dating_app/src/domain/dtos/customers/customers_dto.dart';
import 'package:dating_app/src/domain/dtos/customers/login_dto.dart';
import 'package:dating_app/src/utils/pref_assist.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../domain/dtos/customer_setting/customer_setting_dto.dart';
import '../domain/dtos/profiles/profiles_dto.dart';
import '../domain/dtos/response_base/response_base_dto.dart';
import '../utils/socket_manager.dart';
import '../utils/utils.dart';
import 'api_utils.dart';

abstract class LoginResponseModel {
  CustomerDto? customer;
  int? errorCode;
  String? message;
  BlockedExtraInfoDto? blockExtraInfo;
}

class LoginError extends LoginResponseModel {
  LoginError(int code, String message, {BlockedExtraInfoDto? extraInfo}) {
    super.errorCode = code;
    super.message = message;
    super.blockExtraInfo = extraInfo;
  }
}

class LoginSuccess extends LoginResponseModel {
  LoginSuccess(CustomerDto customer) {
    super.customer = customer;
  }
}

class ApiRegLogin {
  static Future<LoginResponseModel> login(String oAuth2Id) async {
    const String url = "${ApiUtils.END_POINT}/api/v1/login";

    http.Response response = await http.post(
      Uri.parse(url),
      headers: ApiUtils.getHeader(),
      body: jsonEncode({'oAuth2Id': oAuth2Id}),
    );

    switch (response.statusCode) {
      case ApiCode.success:
        final body = json.decode(response.body);
        final resultModel = ResultAPI<LoginDto>.fromJson(
            body, (data) => LoginDto.fromJson(data as Map<String, dynamic>));
        final user = resultModel?.data?.user;
        final token = resultModel?.data?.token;
        if (user == null || token == null) {
          return LoginError(ApiCode.dataFormatUnexpected, resultModel.message);
        } else {
          await PrefAssist.setAccessToken(token);
          await user.profiles?.sortAvatar();
          await StaticInfoManager.shared().loadData();
          await PrefAssist.setMyCustomer(user);

          //Update auth websocket
          SocketManager.shared().updateAuth(token);

          return LoginSuccess(user);
        }
      case ApiCode.forbidden:
        final body = json.decode(response.body);
        final blockedModel = BlockedAccountDto.fromJson(body);
        return LoginError(response.statusCode, response.body,
            extraInfo: blockedModel.extraInfo);
      case ApiCode.unauthorized:
        PrefAssist.setAccessToken('');
        return LoginError(response.statusCode, response.body);
      default:
        return LoginError(response.statusCode, response.body);
    }
  }

  static Future<LoginErrorDto?> sendRegister() async {
    const String url = "${ApiUtils.END_POINT}/api/v1/register";
    //await TelegramDebug.debugMessage(url);

    String encode = jsonEncode(PrefAssist.getMyCustomer());
    Utils.logger('json:' + '${encode}');

    http.Response response = await http.post(Uri.parse(url),
        headers: ApiUtils.getHeader(), body: encode);


    if (response.statusCode != ApiCode.success) {
      if (response.statusCode == ApiCode.unauthorized) {
        PrefAssist.setAccessToken('');
      }
      Utils.logger(
          'statusCode: ${response.statusCode}\nbody: ${response.body}');
      return LoginErrorDto(
          responseCode: response.statusCode, errorMessage: response.body);
    }

    final body = json.decode(response.body);
    final resultModel = ResultAPI<LoginDto>.fromJson(
        body, (data) => LoginDto.fromJson(data as Map<String, dynamic>));
    final user = resultModel?.data?.user;
    final token = resultModel?.data?.token;
    if (user == null || token == null) {
      return LoginErrorDto(
          responseCode: ApiCode.success,
          errorMessage: "Cannot convert user info");
    } else {
      await PrefAssist.setAccessToken(token);
      await PrefAssist.setMyCustomer(user);
      await StaticInfoManager.shared().loadData();
      await ApiRegLogin.mathBot();

      //Update auth websocket
      SocketManager.shared().updateAuth(token);

      return null;
    }
  }

  static Future<int> mathBot() async {
    const String url = "${ApiUtils.END_POINT}/api/v1/match-bot";

    String encode = jsonEncode({"idBot": Const.melohaID});

    http.Response response = await http.post(Uri.parse(url),
        headers: ApiUtils.getHeader(), body: encode);

    Utils.logger('mathBot:${response.body}');
    return response.statusCode;
  }
}
