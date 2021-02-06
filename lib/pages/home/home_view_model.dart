import 'dart:async';

import 'package:TodayYoutuber/models/category.dart' as mCategory;
import 'package:TodayYoutuber/database/database.dart' as db;
import 'package:TodayYoutuber/models/channel.dart' as mChannel;
import 'package:flutter/material.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:TodayYoutuber/main.dart';

class HomeViewModel extends ChangeNotifier {
  List<mCategory.Category> categories = [
    mCategory.Category(id: 99999999, title: "플러터", channels: [
      mChannel.Channel(
          name: "코드팩토리",
          image:
              "https://yt3.ggpht.com/ytc/AAUvwnhZKDZBlIH-AAMyl6Jxit6MdKcqx7a68VDT5mwR=s88-c-k-c0x00ffffff-no-rj",
          link:
              "https://www.youtube.com/channel/UCxZ2AlaT0hOmxzZVbF_j_Sw/featured",
          subscribers: "구독자 1280 명",
          categoryId: 99999999)
    ]),
    mCategory.Category(id: 99999, title: "리액트", channels: [
      mChannel.Channel(
          name: "코드팩토리",
          image:
              "https://yt3.ggpht.com/ytc/AAUvwnhZKDZBlIH-AAMyl6Jxit6MdKcqx7a68VDT5mwR=s88-c-k-c0x00ffffff-no-rj",
          link:
              "https://www.youtube.com/channel/UCxZ2AlaT0hOmxzZVbF_j_Sw/featured",
          subscribers: "구독자 1280 명",
          categoryId: 99999)
    ])
  ];

  // * youtube 앱으로부터 공유 인텐트를 받는 경우
  void subscribeSharingIntent(Function onReceiveSharingIntent) {}

  void getUrlWhenStartedBySharingIntent(Function onReceiveSharingIntent) {
    ReceiveSharingIntent.getInitialText().then((String value) {
      if (value == null || value.isEmpty) return;

      onReceiveSharingIntent(value);
    });
  }

  void unsubscribeSharingIntent() {
    // _intentDataStreamSubscription.cancel();
  }

  Future<void> getCategoriesFromDB() async {
    final List<db.Category> results = await database.allCategoryEntries;

    for (var i = 0; i < results.length; ++i) {
      categories.add(mCategory.Category(
          id: results[i].id, title: results[i].title, channels: []));
    }

    notifyListeners();
  }

  Future<void> getChannelsFromDB() async {
    final List<db.Channel> results = await database.allChannelEntries;

    for (var i = 0; i < results.length; ++i) {
      var channel = results[i];

      mCategory.categoryHashMap[results[i].categoryId].add(mChannel.Channel(
          id: channel.id,
          name: channel.name,
          image: channel.image,
          link: channel.link,
          subscribers: channel.subscribers,
          categoryId: channel.categoryId));
    }

    notifyListeners();
  }

  // * 카테고리
  void addCategory(mCategory.Category newCategory) async {
    categories.add(newCategory);

    // * id 는 auto increment이므로 필수가 아님.
    // ignore: missing_required_param
    await database.addCategory(db.Category(title: newCategory.title));

    notifyListeners();
  }

  void addEmptyCategory() async {
    // * id 는 auto increment이므로 필수가 아님.
    // ignore: missing_required_param
    final int id = await database.addCategory(db.Category(title: "새카테고리"));

    addCategory(mCategory.Category(id: id, title: "새카테고리", channels: []));
    notifyListeners();
  }

  void setCategoryTitle(int categoryIndex, String newCategoryIitle) async {
    categories[categoryIndex].setTitle(newCategoryIitle);
    await database.updateCategory(
        db.Category(id: categories[categoryIndex].id, title: "새카테고리"));
    notifyListeners();
  }

  // * 채널
  List<mChannel.Channel> getChannels(int categoryIndex) =>
      categories[categoryIndex].channels;
  int getLengthOfChannels(int categoryIndex) =>
      categories[categoryIndex].channels.length;

  void addChannel(int categoryIndex, mChannel.Channel channel) async {
    assert(channel != null);
    assert(categoryIndex <= categories.length);

    // * autoIncrement 필드 이므로 int 불필요.
    // ignore: missing_required_param
    int id = await database.addChannel(db.Channel(
        name: channel.name,
        image: channel.image,
        link: channel.link,
        subscribers: channel.subscribers,
        categoryId: categories[categoryIndex].id,
        likes: channel.likes,
        isLike: channel.isLike));

    channel.setId(id);

    mCategory.categoryHashMap[categories[categoryIndex].id].add(channel);
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
