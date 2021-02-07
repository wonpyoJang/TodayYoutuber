import 'package:TodayYoutuber/models/channel.dart';
import 'package:TodayYoutuber/main.dart';
import 'dart:collection';
import 'package:TodayYoutuber/database/database.dart' as db;
import 'dart:convert';

HashMap<int, List<Channel>> categoryHashMap = HashMap<int, List<Channel>>();

// * 여기는 channels getter로 인해 josnSerializable을 제외하고 직접 관리합니다.
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

Category _$CategoryFromJson(Map<String, dynamic> json) {
  return Category(
    id: json['id'] as int,
    title: json['title'] as String,
    channels: (json['channels'] as List)
        ?.map((e) =>
            e == null ? null : Channel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'channels': jsonDecode(jsonEncode(instance.channels)),
    };
