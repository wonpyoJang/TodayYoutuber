import 'package:TodayYoutuber/models/category.dart';
import 'package:TodayYoutuber/models/channel.dart';
import 'package:flutter/material.dart';

class SelectShareItemViewModel extends ChangeNotifier {
  List<Category> categories;

  int numberOfSelectedItem() {
    int cnt = 0;

    for (Category category in categories) {
      for (Channel channel in category.channels) {
        if (channel.selected) {
          ++cnt;
        }
      }
    }
    return cnt;
  }
}
