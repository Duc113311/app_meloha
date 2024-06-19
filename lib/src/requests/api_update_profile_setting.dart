import 'dart:convert';
import 'package:dating_app/src/data/remote/api_endpoint.dart';
import 'package:dating_app/src/domain/dtos/customer_setting/customer_setting_dto.dart';
import 'package:dating_app/src/domain/dtos/customers/customers_dto.dart';
import 'package:dating_app/src/domain/dtos/profiles/avatar_dto.dart';
import 'package:dating_app/src/domain/dtos/profiles/prompt_dto.dart';
import 'package:dating_app/src/utils/change_notifiers/verify_account_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../utils/pref_assist.dart';
import '../utils/utils.dart';
import 'api_utils.dart';

class ApiProfileSetting {
  static int latRequest = 0;
  static int request_capping = 1000;

  static Future<int> updateMyCustomerProfile() async {
    const String url = "${ApiUtils.END_POINT}/api/v1/profile";
    final profile = PrefAssist.getMyCustomer().profiles;
    final bodyJson = {"profiles": profile};
    final bodyEncode = jsonEncode(bodyJson);

    http.Response response = await http.post(
      Uri.parse(url),
      headers: ApiUtils.getHeader(),
      body: bodyEncode,
    );

    Utils.logger(
        'updateMyCustomerProfile: ${response.statusCode}\nbody: ${response.body}');
    if (response.statusCode != ApiCode.success) {
      return response.statusCode;
    }

    return ApiCode.success;
  }

  static Future<PromptDto?> updatePrompt(PromptDto prompt) async {
    const String url = "${ApiUtils.END_POINT}/api/v1/profile/prompts";
    final jsonBody = jsonEncode(prompt);

    http.Response response = await http.post(
      Uri.parse(url),
      headers: ApiUtils.getHeader(),
      body: jsonBody,
    );

    final body = json.decode(response.body);
    final promptResponse = PromptDto.fromJson(body['data']);
    Utils.logger('update prompt: ${response.statusCode}');

    return promptResponse;
  }

  static Future<int> deletePrompt(PromptDto prompt) async {
    if (prompt.id == null) {
      return -1;
    }
    const String url = "${ApiUtils.END_POINT}/api/v1/profile/prompts";

    final bodyEncode = jsonEncode({"id": prompt.id});

    http.Response response = await http.delete(
      Uri.parse(url),
      headers: ApiUtils.getHeader(),
      body: bodyEncode,
    );

    if (response.statusCode != ApiCode.success) {
      Utils.logger(
          'statusCode: ${response.statusCode}\nbody: ${response.body}');
      return response.statusCode;
    }

    return ApiCode.success;
  }

  static Future<CustomerDto?> getProfile({bool force = false}) async {
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    if (!force && currentTime - latRequest < request_capping) {
      debugPrint('Vua cap nhat xong');
      return null;
    }
    latRequest = currentTime;

    const String url = "${ApiUtils.END_POINT}/api/v1/profile";

    http.Response response = await http.get(
      Uri.parse(url),
      headers: ApiUtils.getHeader(),
    );

    if (response.statusCode == ApiCode.success) {
      Utils.logger(
          'statusCode: ${response.statusCode}\nbody: ${response.body}');

      final body = json.decode(response.body);
      final customerDto = CustomerDto.fromJson(body['data']);
      customerDto.profiles?.sortAvatar();

      await PrefAssist.setMyCustomer(customerDto);
      if (customerDto.explore?.verified != null) {
        VerifyAccountNotifier.shared.updateStatus(customerDto.explore!.verified, autoSave: false);
      }

      return customerDto;

    } else {
      return null;
    }
  }

  static Future<int> updateMyCustomerSetting() async {
    if (PrefAssist.getAccessToken().isEmpty) {
      debugPrint("Token is empty");
      return -1;
    }
    const String url = "${ApiUtils.END_POINT}/api/v1/setting";
    final customer = PrefAssist.getMyCustomer();

    final bodyJson = {
      "activeStatus": customer.activeStatus,
      "settings": customer.settings,
      "plusCtrl": customer.plusCtrl,
      "location": customer.location
    };
    final bodyEncode = jsonEncode(bodyJson);

    http.Response response = await http.post(
      Uri.parse(url),
      headers: ApiUtils.getHeader(),
      body: bodyEncode,
    );

    if (response.statusCode != ApiCode.success) {
      Utils.logger(
          'statusCode: ${response.statusCode}\nbody: ${response.body}');
      return response.statusCode;
    }

    return ApiCode.success;
  }

  static Future<List<AvatarDto>> getProfileImages() async {
    const String url = "${ApiUtils.END_POINT}/${AppPath.profileImages}";

    http.Response response =
        await http.get(Uri.parse(url), headers: ApiUtils.getHeader());

    if (response.statusCode == ApiCode.success) {
      Utils.logger(
          'statusCode: ${response.statusCode}\nbody: ${response.body}');

      final body = json.decode(response.body);
      final resultDto = AvatarProfileDto.fromJson(body['data']);

      PrefAssist.getMyCustomer().profiles?.avatars = resultDto.data;
      PrefAssist.getMyCustomer().profiles?.sortAvatar();

      await PrefAssist.saveMyCustomer();

      return resultDto.data;
    } else {
      return [];
    }
  }

// static Future<List<AvatarDto>> addImages(List<AvatarDto> newImages) async {
//   const String url = "${ApiUtils.END_POINT}/${AppPath.profileImages}";
//
//   Map<String, dynamic> jsonMap = {};
//   jsonMap['images'] = newImages.map((e) => e.toJson()).toList();
//
//   http.Response response = await http.post(
//     Uri.parse(url),
//     headers: ApiUtils.getHeader(),
//     body: jsonEncode(jsonMap),
//   );
//
//   if (response.statusCode == ApiCode.success) {
//     Utils.logger('statusCode: ${response.statusCode}\nbody: ${response.body}');
//
//     final body = json.decode(response.body);
//     final resultDto = AvatarProfileDto.fromJson(body['data']);
//
//     PrefAssist.getMyCustomer().profiles?.avatars = resultDto.data;
//     PrefAssist.getMyCustomer().profiles?.sortAvatar();
//     await PrefAssist.saveMyCustomer();
//
//     return resultDto.data;
//   } else {
//     return [];
//   }
// }
//
// static Future<int> deleteImage(List<String> imageIds) async {
//   const String url = "${ApiUtils.END_POINT}/${AppPath.profileImages}";
//
//   Map<String, dynamic> jsonMap = {};
//
//   jsonMap['imageId'] = imageIds;
//
//   http.Response response = await http.delete(
//     Uri.parse(url),
//     headers: ApiUtils.getHeader(),
//     body: jsonEncode(jsonMap),
//   );
//
//   if (response.statusCode != ApiCode.success) {
//     Utils.logger('statusCode: ${response.statusCode}\nbody: ${response.body}');
//     return response.statusCode;
//   }
//
//   return ApiCode.success;
// }
//
// static Future<int> changeImageOrder(List<AvatarDto> newImages) async {
//   if (newImages.isEmpty) {return -1;}
//
//   const String url = "${ApiUtils.END_POINT}/${AppPath.changeImageOrder}";
//
//   List<Map<String, dynamic>> jsonImages = [];
//   for (int index = 0; index < newImages.length; index ++) {
//     Map<String, dynamic> jsonImage = {};
//     jsonImage['id'] = newImages[index].id ?? '';
//     jsonImage['order'] = index;
//
//     jsonImages.add(jsonImage);
//   }
//
//   Map<String, dynamic> jsonMap = {};
//   jsonMap['images'] = jsonImages;
//
//   http.Response response = await http.post(
//     Uri.parse(url),
//     headers: ApiUtils.getHeader(),
//     body: jsonEncode(jsonMap),
//   );
//
//   if (response.statusCode != ApiCode.success) {
//     Utils.logger('statusCode: ${response.statusCode}\nbody: ${response.body}');
//     return response.statusCode;
//   }
//
//   return ApiCode.success;
// }
}
