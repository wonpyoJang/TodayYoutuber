import 'package:TodayYoutuber/common/my_in_app_browser.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

part 'channel.g.dart';

@JsonSerializable(nullable: true)
class Channel {
  final String name;
  final String image;
  final String link;
  int subscribers;
  int likes;
  bool isLike;

  Channel({
    this.name,
    this.image,
    this.link,
    this.subscribers,
    this.likes,
    this.isLike = false,
  });

  bool setLike() => this.isLike = true;
  bool unsetLike() => this.isLike = false;

  void openUrlWithInappBrowser() async {
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
