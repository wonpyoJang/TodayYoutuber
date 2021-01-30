import 'package:json_annotation/json_annotation.dart';

import 'package:TodayYoutuber/models/channel.dart';

part 'category.g.dart';

@JsonSerializable(nullable: true)
class Category {
  String title;
  final List<Channel> channels;

  Category({
    this.title,
    this.channels,
  }) {
    print("[create Instance] Category : ${toString()}");
    assert(title != null && title.isNotEmpty);
    assert(channels != null);
  }

  void setTitle(String newTitle) {
    this.title = newTitle;
  }

  void addChannel(Channel channel) {
    assert(channel != null);

    channels.add(channel);
  }

  void deleteChannel(Channel channel) {
    assert(channel != null);

    channels.remove(channel);
  }

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}
