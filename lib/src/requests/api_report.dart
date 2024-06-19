import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/utils.dart';
import 'api_utils.dart';

class ApiReport {

  static Future<int> reportUser(String reportedSubjectId, String reasonCode, {String codeTitle = '', String codeDetail = '', String comments = '', List<String>? imageReports}) async {
    const String url = "${ApiUtils.END_POINT}/api/v1/report";
    final bodyJson = {"reportedSubjectId": reportedSubjectId, "reasonCode": reasonCode, "codeTitle": codeTitle, "codeDetail": codeDetail, "comments": comments, "imageReports": imageReports ?? []};
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
}
