import 'package:json_annotation/json_annotation.dart';

part 'user_info.g.dart';

@JsonSerializable()
class UserInfo {
  @JsonKey(name: 'display_name')
  final String name;
  final String description;
  @JsonKey(name: 'avatar_url')
  final String avatarUrl;

  UserInfo(this.name, this.description, this.avatarUrl);

  factory UserInfo.fromJson(Map<String, dynamic> json) => _$UserInfoFromJson(json);

  Map<String, dynamic> toJson() => _$UserInfoToJson(this);
}