import 'dart:async';

import 'package:TodayYoutuber/models/category.dart' as mCategory;
import 'package:TodayYoutuber/database/database.dart' as db;
import 'package:TodayYoutuber/models/channel.dart' as mChannel;
import 'package:flutter/material.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:TodayYoutuber/main.dart';
// ignore: implementation_imports
import 'package:sqlite3/src/api/exception.dart';

enum DBAccessResult { SUCCESS, DUPLICATED_CATEGORY, DUPLICATED_CHANNEL, FAIL }

class HomeViewModel extends ChangeNotifier {
  List<mCategory.Category> categories = [];

  void clear() {
    categories.clear();
    mCategory.categoryHashMap.clear();
  }

  void getUrlWhenStartedBySharingIntent(Function onReceiveSharingIntent) {
    ReceiveSharingIntent.getInitialText().then((String value) {
      if (value == null || value.isEmpty) return;

      onReceiveSharingIntent(value);
    });
  }

  Future<DBAccessResult> getCategoriesFromDB() async {
    List<db.Category> results;

    try {
      results = await database.allCategoryEntries;
    } catch (e) {
      assert(false);
      return DBAccessResult.FAIL;
    }

    if (results == null) {
      return DBAccessResult.FAIL;
    }

    for (var i = 0; i < results.length; ++i) {
      categories.add(mCategory.Category(
          id: results[i].id, title: results[i].title, channels: []));
    }

    notifyListeners();
    return DBAccessResult.SUCCESS;
  }

  Future<DBAccessResult> getChannelsFromDB() async {
    List<db.Channel> results;

    try {
      results = await database.allChannelEntries;
    } catch (e) {
      assert(false);
      return DBAccessResult.FAIL;
    }

    if (results == null) {
      return DBAccessResult.FAIL;
    }

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
    return DBAccessResult.SUCCESS;
  }

  // * 카테고리
  Future<DBAccessResult> addCategory(mCategory.Category newCategory) async {
    assert(newCategory != null, newCategory.title != null);

    int id;

    try {
      // id 는 auto increment이므로 필수가 아님.
      // ignore: missing_required_param
      id = await database.addCategory(db.Category(title: newCategory.title));
    } on SqliteException catch (e) {
      assert(false);
      if (e.extendedResultCode == 2067) {
        return DBAccessResult.DUPLICATED_CATEGORY;
      }
    } catch (e) {
      assert(false);
      return DBAccessResult.FAIL;
    } finally {
      isLoading.add(false);
    }

    newCategory.setId(id);
    categories.add(newCategory);
    mCategory.categoryHashMap[id] = [];

    notifyListeners();
    return DBAccessResult.SUCCESS;
  }

  // * 카테고리
  Future<DBAccessResult> deleteCategory(mCategory.Category category) async {
    assert(category != null, category.title != null);

    try {
      // id 는 auto increment이므로 필수가 아님.
      // ignore: missing_required_param
      await database
          .deleteCategory(db.Category(id: category.id, title: category.title));
    } catch (e) {
      assert(false);
      return DBAccessResult.FAIL;
    }

    categories.remove(category);

    notifyListeners();
    return DBAccessResult.SUCCESS;
  }

  Future<DBAccessResult> addEmptyCategory() async {
    int id;

    try {
      // id 는 auto increment이므로 필수가 아님.
      // ignore: missing_required_param
      id = await database.addCategory(db.Category(title: "새카테고리"));
    } catch (e) {
      assert(false);
      return DBAccessResult.FAIL;
    }

    if (id == null) {
      return DBAccessResult.FAIL;
    }

    addCategory(mCategory.Category(id: id, title: "새카테고리", channels: []));
    notifyListeners();
    return DBAccessResult.SUCCESS;
  }

  Future<DBAccessResult> setCategoryTitle(
      int categoryIndex, String newCategoryIitle) async {
    assert(categoryIndex != null &&
        categoryIndex >= 0 &&
        categoryIndex < categories.length);
    assert(newCategoryIitle != null && newCategoryIitle.isNotEmpty);

    categories[categoryIndex].setTitle(newCategoryIitle);

    try {
      await database.updateCategory(
          db.Category(id: categories[categoryIndex].id, title: "새카테고리"));
    } catch (e) {
      assert(false);
      return DBAccessResult.FAIL;
    }

    notifyListeners();
    return DBAccessResult.SUCCESS;
  }

  // * 채널
  List<mChannel.Channel> getChannels(int categoryIndex) =>
      categories[categoryIndex].channels;

  int getLengthOfChannels(int categoryIndex) =>
      categories[categoryIndex].channels.length;

  Future<DBAccessResult> addChannel(
      int categoryIndex, mChannel.Channel channel) async {
    assert(channel != null);
    assert(categoryIndex != null && categoryIndex <= categories.length);

    // todo : 현재 순차적 리스트 탐색으로 중복 채널 여부를 탐색하고 있는데, 추후 탐색 방법을 hash에 의한 존재 여부 확인으로 변경할 것.
    bool isExistInThisList = mCategory
        .categoryHashMap[categories[categoryIndex].id]
        .any((channelItem) => channelItem.name == channel.name);

    if (isExistInThisList) {
      return DBAccessResult.DUPLICATED_CHANNEL;
    }

    int newChannelId;

    try {
      // autoIncrement 필드 이므로 int 불필요.
      // ignore: missing_required_param
      newChannelId = await database.addChannel(db.Channel(
          name: channel.name,
          image: channel.image,
          link: channel.link,
          subscribers: channel.subscribers,
          categoryId: categories[categoryIndex].id,
          likes: channel.likes,
          isLike: channel.isLike));
    } catch (e) {
      assert(false);
      return DBAccessResult.FAIL;
    }

    if (newChannelId == null) {
      return DBAccessResult.FAIL;
    }

    channel.setId(newChannelId);

    mCategory.categoryHashMap[categories[categoryIndex].id].add(channel);
    notifyListeners();

    return DBAccessResult.SUCCESS;
  }

  Future<DBAccessResult> deleteChannel(
      int categoryIndex, mChannel.Channel channel) async {
    assert(channel != null);
    assert(categoryIndex != null && categoryIndex <= categories.length);

    try {
      // autoIncrement 필드 이므로 int 불필요.
      // ignore: missing_required_param
      await database.deleteChannel(db.Channel(
          id: channel.id,
          name: channel.name,
          image: channel.image,
          link: channel.link,
          subscribers: channel.subscribers,
          categoryId: categories[categoryIndex].id,
          likes: channel.likes,
          isLike: channel.isLike));
    } catch (e) {
      assert(false);
      return DBAccessResult.FAIL;
    }

    mCategory.categoryHashMap[categories[categoryIndex].id].remove(channel);
    notifyListeners();

    return DBAccessResult.SUCCESS;
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
