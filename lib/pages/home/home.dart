import 'package:TodayYoutuber/common/dialogs.dart';
import 'package:TodayYoutuber/common/loading_overlay.dart';
import 'package:TodayYoutuber/common/route_manager.dart';
import 'package:TodayYoutuber/models/category.dart';
import 'package:TodayYoutuber/models/channel.dart';
import 'package:TodayYoutuber/models/share_event.dart';
import 'package:TodayYoutuber/pages/home/home_view_model.dart';
import 'package:TodayYoutuber/pages/home/widget/bottom_sheet_for_adding_channel.dart';
import 'package:TodayYoutuber/pages/home/widget/channel_list.dart';
import 'package:TodayYoutuber/pages/home/widget/text_field_dialog.dart';
import 'package:TodayYoutuber/pages/received_channels/received_channels.dart';
import 'package:TodayYoutuber/pages/received_channels/recevied_channels_view_model.dart';
import 'package:TodayYoutuber/pages/select_share_item/select_share_item_view_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:TodayYoutuber/main.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  TabController _tabController;

  void initState() {
    this.getDatasFromDB(context);
    logger.d("[initState] HomeScreen");
    super.initState();
    HomeViewModel _homeViewModel =
        Provider.of<HomeViewModel>(context, listen: false);

    urlReceivedEvent.stream.listen((url) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        isLoading.add(false);
        int selectedCategoryIndex = await showModalBttomSheetForAddingChanel(
            context, url, (selectedCategoryIndex, parsedChannel) async {
          // todo : 이 부분은 getUrlWhenStartedBySharingINtent에 들어가는 콜백에서 중복된다.
          DBAccessResult result = await _homeViewModel.addChannel(
              selectedCategoryIndex, parsedChannel);

          if (result == DBAccessResult.DUPLICATED_CHANNEL) {
            await showDuplicatedChannelDailog(context);
            return;
          } else if (result == DBAccessResult.FAIL) {
            await showDBConnectionFailDailog(context);
            return;
          }
        });
        _tabController.animateTo(selectedCategoryIndex);
      });
    });
    _homeViewModel.getUrlWhenStartedBySharingIntent((url) async {
      int selectedCategoryIndex = await showModalBttomSheetForAddingChanel(
          context, url, (selectedCategoryIndex, parsedChannel) async {
        DBAccessResult result = await _homeViewModel.addChannel(
            selectedCategoryIndex, parsedChannel);

        if (result == DBAccessResult.DUPLICATED_CHANNEL) {
          await showDuplicatedChannelDailog(context);
          return;
        } else if (result == DBAccessResult.FAIL) {
          await showDBConnectionFailDailog(context);
          return;
        }
      });
      _tabController.animateTo(selectedCategoryIndex);
    });

    this.initDynamicLinks(context);

    _tabController = TabController(
        length: _homeViewModel.categories.length + 1,
        vsync: this,
        initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    logger.d("[build] HomeScreen");

    return Scaffold(
      appBar: buildAppBar(context),
      body: buildBody(context),
    );
  }

  @override
  void dispose() {
    logger.d("[dispse] HomeScreen");
    super.dispose();
  }

  void initDynamicLinks(BuildContext context) async {
    var receviedChannelsViewModel =
        Provider.of<ReceivedChannelsViewModel>(context, listen: false);

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      isLoading.add(true);

      final Uri deepLink = dynamicLink?.link;

      if (deepLink != null) {
        DataSnapshot sharedData = await databaseReference
            .child(deepLink.queryParameters["shareKey"])
            .once();

        var json = sharedData.value.cast<String, dynamic>();
        json['user'] = json['user'].cast<String, dynamic>();
        json['categories'] = json['categories']
            .map((category) => category.cast<String, dynamic>())
            .toList();

        for (int i = 0; i < json['categories'].length; ++i) {
          json['categories'][i]['channels'] = json['categories'][i]['channels']
              .map((channel) => channel.cast<String, dynamic>())
              .toList();
        }

        var sharedEvent =
            ShareEvent.fromJson(sharedData.value.cast<String, dynamic>());

        receviedChannelsViewModel.sharedEvent = sharedEvent;

        isLoading.add(false);

        Navigator.pushNamed(context, RouteLists.receivedChannels,
            arguments: ReceivedChannelsArgument(sharedEvent: sharedEvent));
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });

    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      isLoading.add(true);

      DataSnapshot sharedData = await databaseReference
          .child(deepLink.queryParameters["shareKey"])
          .once();

      var json = sharedData.value.cast<String, dynamic>();
      json['user'] = json['user'].cast<String, dynamic>();
      json['categories'] = json['categories']
          .map((category) => category.cast<String, dynamic>())
          .toList();

      for (int i = 0; i < json['categories'].length; ++i) {
        json['categories'][i]['channels'] = json['categories'][i]['channels']
            .map((channel) => channel.cast<String, dynamic>())
            .toList();
      }

      var sharedEvent =
          ShareEvent.fromJson(sharedData.value.cast<String, dynamic>());

      receviedChannelsViewModel.sharedEvent = sharedEvent;

      isLoading.add(false);

      Navigator.pushNamed(context, RouteLists.receivedChannels,
          arguments: ReceivedChannelsArgument(sharedEvent: sharedEvent));
    }
  }

  void getDatasFromDB(BuildContext context) async {
    HomeViewModel _homeViewModel =
        Provider.of<HomeViewModel>(context, listen: false);
    List<Category> categories = _homeViewModel.categories;

    _homeViewModel.clear();
    try {
      await _homeViewModel.getCategoriesFromDB();
      await _homeViewModel.getChannelsFromDB();
    } catch (_) {}
    _tabController = TabController(vsync: this, length: categories.length + 1);

    setState(() {});
  }

  Widget buildAppBar(BuildContext context) {
    HomeViewModel _homeViewModel =
        Provider.of<HomeViewModel>(context, listen: true);
    List<Category> categories = _homeViewModel.categories;

    return AppBar(
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(40.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: TabBar(
            indicatorWeight: 2.0,
            indicatorPadding: EdgeInsets.zero,
            controller: _tabController,
            labelPadding: EdgeInsets.symmetric(horizontal: 5),
            isScrollable: true,
            tabs: [
              ...categories.map((category) {
                final categoryIndex = categories.indexOf(category);
                return Tab(
                    iconMargin: EdgeInsets.zero,
                    child: GestureDetector(
                        onLongPress: () async {
                          await onPressedCategoryMenu(context, categoryIndex);
                        },
                        onDoubleTap: () async =>
                            onPressedCategoryMenu(context, categoryIndex),
                        child: Container(
                            height: 50,
                            width: 65,
                            child: Center(child: Text(category.title)))));
              }),
              Tab(
                  child: InkWell(
                      onTap: () async {
                        isLoading.add(true);
                        await addNewCategory(context);
                        isLoading.add(false);
                      },
                      child: Container(
                          height: 40,
                          width: 70,
                          child: Center(child: Text("+ 추가하기"))))),
            ],
          ),
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('유랭카'),
          GestureDetector(
            onTap: () async {
              isLoading.add(true);

              var shareItemViewModel =
                  Provider.of<SelectShareItemViewModel>(context, listen: false);

              shareItemViewModel.categories = categories;

              for (var category in categories) {
                for (Channel channel in category.channels) {
                  channel.selected = true;
                }
              }

              isLoading.add(false);

              await Navigator.of(context)
                  .pushNamed(RouteLists.selectShareItemScreen);
            },
            child: Container(
                width: 44,
                height: 44,
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Icon(Icons.share)),
          ),
        ],
      ),
    );
  }

  Future onPressedCategoryMenu(BuildContext context, int categoryIndex) async {
    HomeViewModel _homeViewModel =
        Provider.of<HomeViewModel>(context, listen: false);
    List<Category> categories = _homeViewModel.categories;
    Category category = categories[categoryIndex];

    await showCategoryMenu(context, onPressedEdit: () async {
      String newCategoryTitle = await showTextFieldDialog(context);

      if (newCategoryTitle == null) {
        return;
      }

      DBAccessResult result = await _homeViewModel.setCategoryTitle(
          categoryIndex, newCategoryTitle);
      if (result == DBAccessResult.FAIL) {
        await showDBConnectionFailDailog(context);
        return;
      }
    }, onPressedDelete: () async {
      DBAccessResult result = await _homeViewModel.deleteCategory(category);
      if (result == DBAccessResult.FAIL) {
        await showDBConnectionFailDailog(context);
        return;
      }
    });

    setState(() {
      _tabController =
          new TabController(vsync: this, length: categories.length + 1);
    });
  }

  Widget buildBody(BuildContext context) {
    HomeViewModel _homeViewModel =
        Provider.of<HomeViewModel>(context, listen: true);
    List<Category> categories = _homeViewModel.categories;

    return LoadingOverlay(
      child: TabBarView(
        controller: _tabController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          ...categories.map((category) {
            final categoryIndex = categories.indexOf(category);
            return ChannelList(
              category: category,
              onTapDeleteButton: (channelIndex) async {
                isLoading.add(true);
                var result = await _homeViewModel.deleteChannel(
                    categoryIndex, category.channels[channelIndex]);

                if (result == DBAccessResult.FAIL) {
                  showDBConnectionFailDailog(context);
                }
                isLoading.add(false);
              },
            );
          }),
          Center(
              child: InkWell(
                  onTap: () async {
                    isLoading.add(true);
                    await addNewCategory(context);
                    isLoading.add(false);
                  },
                  child: Container(
                      width: 100, height: 100, child: Text("+ 추가하기")))),
        ],
      ),
    );
  }

  Future<void> addNewCategory(BuildContext context) async {
    HomeViewModel _homeViewModel =
        Provider.of<HomeViewModel>(context, listen: false);
    List<Category> categories = _homeViewModel.categories;

    String newCategoryTitle = await showTextFieldDialog(context);

    if (newCategoryTitle == null) {
      return;
    }

    DBAccessResult result = await _homeViewModel
        .addCategory(Category(title: newCategoryTitle, channels: []));

    if (result == DBAccessResult.DUPLICATED_CATEGORY) {
      await showDuplicatedCategoryDailog(context);
      return;
    } else if (result == DBAccessResult.FAIL) {
      await showDBConnectionFailDailog(context);
      return;
    }

    setState(() {
      _tabController =
          new TabController(vsync: this, length: categories.length + 1);
    });
  }
}
