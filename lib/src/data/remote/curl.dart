import 'dart:convert';

import 'package:dio/dio.dart';

extension Curl on RequestOptions {
  String toCurl() {
    String curl = "";

    String header = headers
        .map((key, value) {
      if (key == "content-type" && value.toString().contains("multipart/form-data")) {
        value = "multipart/form-data;";
      }
      return MapEntry(key, "-H '$key: $value'");
    })
        .values
        .join(" ");
    String url ='$baseUrl$path';
    if (queryParameters.isNotEmpty) {
      String query = queryParameters
          .map((key, value) {
        return MapEntry(key, "$key=$value");
      })
          .values
          .join("&");

      url += (url.contains("?")) ? query : "?$query";
    }
    if (method == "GET") {
      curl += " $header '$url'";
    } else {
      Map<String, dynamic> files = {};
      String postData = "-d ''";
      if (data != null) {
        if (data is FormData) {
          FormData fData = data as FormData;
          for (var element in fData.files) {
            MultipartFile file = element.value;
            files[element.key] = "@${file.filename}";
          }
          for (var element in fData.fields) {
            files[element.key] = element.value;
          }
          if (files.isNotEmpty) {
            postData = files
                .map((key, value) => MapEntry(key, "-F '$key=$value'"))
                .values
                .join(" ");
          }
        } else if (data is Map<String, dynamic>) {
          files.addAll(data);

          if (files.isNotEmpty) {
            postData = "-d '${json.encode(files).toString()}'";
          }
        }
      }

      String method = this.method.toString();
      curl += " -X $method $postData $header '$url'";
    }
    curl = 'curl $curl';
    return curl;
  }
}
