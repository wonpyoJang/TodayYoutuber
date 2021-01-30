import 'dart:async';

import 'package:TodayYoutuber/models/category.dart';
import 'package:TodayYoutuber/models/channel.dart';
import 'package:flutter/material.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class HomeViewModel extends ChangeNotifier {
  List<Category> categories = [
    Category(title: "flutter", channels: [
      Channel(
        name: "코드팩토리",
        image:
            "https://yt3.ggpht.com/ytc/AAUvwnhZKDZBlIH-AAMyl6Jxit6MdKcqx7a68VDT5mwR=s88-c-k-c0x00ffffff-no-rj",
        link:
            "https://www.youtube.com/channel/UCxZ2AlaT0hOmxzZVbF_j_Sw/featured",
        subscribers: "구독자 1280 명",
      )
    ])
  ];

  StreamSubscription _intentDataStreamSubscription;

  // * youtube 앱으로부터 공유 인텐트를 받는 경우
  void subscribeSharingIntent(Function onReceiveSharingIntent) {
    // For sharing or opening urls/text coming from outside the app while the app is in the memory
    _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String value) {
      if (value == null && value.isEmpty) return;

      onReceiveSharingIntent(value);
    }, onError: (err) {
      print("getLinkStream error: $err");
    });

    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialText().then((String value) {
      if (value == null && value.isEmpty) return;

      onReceiveSharingIntent(value);
    });
  }

  void unsubscribeSharingIntent() {
    _intentDataStreamSubscription.cancel();
  }

  // * 카테고리

  // * 채널
  List<Channel> getChannels(int categoryIndex) =>
      categories[categoryIndex].channels;
  int getLengthOfChannels(int categoryIndex) =>
      categories[categoryIndex].channels.length;

  void addChannel(int categoryIndex, Channel channel) {
    assert(channel != null);
    assert(categoryIndex <= categories.length);

    categories[categoryIndex].channels.add(channel);
    notifyListeners();
  }

  // * 좋아요
  void setLike(int categoryIndex, int channelIndex) {
    checkNullAndRange(categoryIndex, channelIndex);

    categories[categoryIndex].channels[channelIndex].setLike();
  }

  void unsetLike(int categoryIndex, int channelIndex) {
    checkNullAndRange(categoryIndex, channelIndex);

    categories[categoryIndex].channels[channelIndex].unsetLike();
  }

  void toggleLike(int categoryIndex, int channelIndex) {
    checkNullAndRange(categoryIndex, channelIndex);

    categories[categoryIndex].channels[channelIndex].toggleLike();

    notifyListeners();
  }

  void checkNullAndRange(int categoryIndex, int channelIndex) {
    assert(categoryIndex != null && categoryIndex >= 0);
    assert(categoryIndex < categories.length);

    assert(channelIndex != null && channelIndex >= 0);
    assert(channelIndex < categories[categoryIndex].channels.length);
  }
}
