import 'package:TodayYoutuber/models/category.dart';
import 'package:TodayYoutuber/models/channel.dart';
import 'package:TodayYoutuber/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'share_event.g.dart';

@JsonSerializable(nullable: true, explicitToJson: true)
class ShareEvent {
  String url;
  User user;
  List<Category> categories;

  ShareEvent({this.url, this.user, this.categories}) {
    assert(url != null && url.isNotEmpty);
    assert(user != null);
    assert(categories != null && categories.isNotEmpty);
  }

  List<Category> getSeletecChannels() {
    List<Category> results = [];

    for (var category in categories) {
      List<Channel> selectedChannels = [];

      for (Channel channel in category.channels) {
        if (channel.selected) {
          selectedChannels.add(channel);
        }
      }

      if (selectedChannels.length > 0) {
        results
            .add(Category(title: category.title, channels: selectedChannels));
      }
    }

    return results;
  }

  factory ShareEvent.fromJson(Map<String, dynamic> json) =>
      _$ShareEventFromJson(json);
  Map<String, dynamic> toJson() => _$ShareEventToJson(this);
}
