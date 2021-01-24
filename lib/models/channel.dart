import 'package:TodayYoutuber/common/my_in_app_browser.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

part 'channel.g.dart';

@JsonSerializable(nullable: true)
class Channel {
  final String name;
  final String image;
  final String link;
  final String subscribers;
  int likes;
  bool isLike;

  Channel({
    @required this.name,
    @required this.image,
    @required this.link,
    @required this.subscribers,
    this.likes = 0,
    this.isLike = false,
  }) {
    assert(name != null && name.isNotEmpty);
    assert(image != null && image.isNotEmpty);
    assert(link != null && link.isNotEmpty);
    assert(subscribers != null && subscribers.isNotEmpty);
    assert(likes != null && likes >= 0);
    assert(isLike != null);
  }

  bool setLike() => this.isLike = true;
  bool unsetLike() => this.isLike = false;

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
}
