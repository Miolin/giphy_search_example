import 'package:giphy_search_example/src/models/user_info.dart';
import 'package:json_annotation/json_annotation.dart';

part 'gif_info.g.dart';

@JsonSerializable()
class GifInfo {
  final String url;
  final String title;
  final UserInfo user;
  @JsonKey(fromJson: _gifOriginalUrlFromJson, name: 'images')
  final String gifOriginalUrl;

  GifInfo(this.url, this.title, this.user, this.gifOriginalUrl);

  factory GifInfo.fromJson(Map<String, dynamic> json) => _$GifInfoFromJson(json);

  Map<String, dynamic> toJson() => _$GifInfoToJson(this);
}

String _gifOriginalUrlFromJson(dynamic map) {
  return map['original']['url'];
}