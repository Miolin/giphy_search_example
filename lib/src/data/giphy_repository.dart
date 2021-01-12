import 'dart:convert';
import 'dart:io';

import 'package:giphy_search_example/src/models/search_response.dart';
import 'package:giphy_search_example/src/utils/consts.dart';
import 'package:http/http.dart' as http;

class GiphyRepository {
  Future<SearchResponse> searchGif(String text, int limit, int offset) async {
    final url = '${Const.apiEndpoint}gifs/search?q=$text&api_key=${Const.apiKey}';
    final response =  await http.get(url);
    if (response.statusCode != 200) throw HttpException('Failed request');
    return SearchResponse.fromJson(jsonDecode(response.body));
  }
}