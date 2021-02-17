import 'package:TodayYoutuber/models/category.dart';
import 'package:TodayYoutuber/models/channel.dart';
import 'package:TodayYoutuber/models/share_event.dart';
import 'package:flutter/material.dart';

class ReceivedChannelsViewModel extends ChangeNotifier {
  ShareEvent sharedEvent;

  void setSeletedTrue() {
    for (Category category in sharedEvent.categories) {
      category.selected = true;
      for (Channel channel in category.channels) {
        channel.selected = true;
      }
    }
  }

  int numberOfSelectedItem() {
    int cnt = 0;

    for (Category category in sharedEvent.categories) {
      for (Channel channel in category.channels) {
        if (channel.selected) {
          ++cnt;
        }
      }
    }
    return cnt;
  }
}
