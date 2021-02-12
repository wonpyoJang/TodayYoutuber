import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:TodayYoutuber/common/my_in_app_browser.dart';
import 'package:TodayYoutuber/main.dart';
import 'package:TodayYoutuber/database/database.dart' as db;

part 'channel.g.dart';

@JsonSerializable(nullable: true, explicitToJson: true)
class Channel {
  int id;
  final String name;
  final String image;
  final String link;
  final String subscribers;
  int likes;
  bool isLike;
  int categoryId;
  bool selected = false;

  Channel(
      {this.id,
      @required this.name,
      @required this.image,
      @required this.link,
      @required this.subscribers,
      this.likes = 0,
      this.isLike = false,
      this.categoryId}) {
    logger.d("[create Instance] Channel : ${toString()}");
    assert(name != null && name.isNotEmpty);
    assert(image != null && image.isNotEmpty);
    assert(link != null && link.isNotEmpty);
    assert(subscribers != null && subscribers.isNotEmpty);
    assert(likes != null && likes >= 0);
    assert(isLike != null);
  }

  db.Channel toDbModel() {
    return db.Channel(
        id: id,
        name: name,
        image: image,
        link: link,
        subscribers: subscribers,
        likes: likes,
        isLike: isLike,
        categoryId: categoryId);
  }

  void setId(int id) {
    this.id = id;
  }

  bool setLike() => this.isLike = true;
  bool unsetLike() => this.isLike = false;

  void toggleLike() {
    if (this.isLike) {
      this.unsetLike();
    } else {
      this.setLike();
    }
  }

  void openUrlWithInappBrowser() async {
    assert(name != null && name.isNotEmpty);
    assert(image != null && image.isNotEmpty);
    assert(link != null && link.isNotEmpty);
    assert(subscribers != null && subscribers.isNotEmpty);
    assert(likes != null && likes >= 0);
    assert(isLike != null);

    final MyInAppBrowser browser = new MyInAppBrowser();
    await browser.openUrl(
        url: this.link,
        options: InAppBrowserClassOptions(
            inAppWebViewGroupOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
          debuggingEnabled: true,
          useShouldOverrideUrlLoading: true,
          useOnLoadResource: true,
        ))));
  }

  factory Channel.fromJson(Map<String, dynamic> json) =>
      _$ChannelFromJson(json);
  Map<String, dynamic> toJson() => _$ChannelToJson(this);

  @override
  String toString() {
    return 'Channel(name: $name, image: $image, link: $link, subscribers: $subscribers, likes: $likes, isLike: $isLike)';
  }
}
