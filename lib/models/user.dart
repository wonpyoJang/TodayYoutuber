import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(nullable: true, explicitToJson: true)
class User {
  String username;
  String jobTitle;

  User({this.username, this.jobTitle}) {
    assert(username != null && username.isNotEmpty);
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
