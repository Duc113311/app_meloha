import 'dart:convert';

import 'package:dating_app/src/domain/dtos/like_and_top_pick/customers_like_top_dto.dart';
import 'package:dating_app/src/domain/dtos/like_and_top_pick/filter_like_dto.dart';
import 'package:http/http.dart' as http;
import 'api_utils.dart';

class ApiFilterLike {

  static Future<List<CustomersLikeTopDto>> filterUser(FilterBodyDto filter, {int pageSize = -1, int currentPage = 0}) async {
    String url = "${ApiUtils.END_POINT}/api/v1/list-fillter-like?pageSize=$pageSize&currentPage=$currentPage&action=like";
    final bodyEncode = jsonEncode(filter);

    http.Response response = await http.post(
      Uri.parse(url),
      headers: ApiUtils.getHeader(),
      body: bodyEncode,
    );

    final body = json.decode(response.body);
    final model = FilterLikeDto.fromJson(body);
    return model.data.listData;
  }
}
