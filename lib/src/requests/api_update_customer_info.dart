import 'dart:convert';
import 'package:dating_app/src/domain/dtos/customers/customers_dto.dart';
import 'package:http/http.dart' as http;

import '../utils/pref_assist.dart';
import '../utils/utils.dart';
import 'api_utils.dart';

class ApiUpdateCustomerInfo {
  static Future<int> updateMyCustomerGPS(double lat, double long) async {
    PrefAssist.getMyCustomer().location = LocationDto(lat: lat.toString(), long: long.toString());
    PrefAssist.saveMyCustomer();
    const String url = "${ApiUtils.END_POINT}/api/v1/updateGPS";
    http.Response response = await http.post(
      Uri.parse(url),
      headers: ApiUtils.getHeader(),
      body: jsonEncode({
        "location": {"lat": lat.toString(), "long": long.toString()}
      }),
    );

    if (response.statusCode == ApiCode.success) {
      Utils.logger('statusCode: ${response.statusCode}\nbody: ${response.body}');
      return response.statusCode;
    }

    return ApiCode.success;
  }
}
