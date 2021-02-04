import 'package:json_annotation/json_annotation.dart';

import 'package:TodayYoutuber/models/channel.dart';
import 'package:TodayYoutuber/main.dart';
import 'dart:collection';
import 'package:TodayYoutuber/database/database.dart' as db;

part 'category.g.dart';

HashMap<int, List<Channel>> categoryHashMap = HashMap<int, List<Channel>>();

@JsonSerializable(nullable: true)
class Category {
  int id;
  String title;

  get channels => categoryHashMap[id];

  Category({
    this.id,
    this.title,
    List<Channel> channels,
  }) {
    logger.d("[create Instance] Category : ${toString()}");
    assert(title != null && title.isNotEmpty);
    assert(channels != null);
    if (categoryHashMap.containsKey(id)) {
      return;
    } else {
      categoryHashMap[id] = channels;
    }
  }

  db.Category toDbModel() {
    return db.Category(id: id, title: title);
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
