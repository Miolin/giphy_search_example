import 'package:giphy_search_example/src/models/gif_info.dart';
import 'package:giphy_search_example/src/models/pagination.dart';
import 'package:json_annotation/json_annotation.dart';

part 'search_response.g.dart';

@JsonSerializable()
class SearchResponse {
  final List<GifInfo> data;
  final Pagination pagination;

  SearchResponse(this.data, this.pagination);

  factory SearchResponse.fromJson(Map<String, dynamic> json) => _$SearchResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SearchResponseToJson(this);
}