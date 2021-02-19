import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:TodayYoutuber/common/dialogs.dart';
import 'package:TodayYoutuber/common/loading_overlay.dart';
import 'package:TodayYoutuber/common/route_manager.dart';
import 'package:TodayYoutuber/global.dart';
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
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  TabController _tabController;

  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  AdmobBannerSize bannerSize;
  AdmobInterstitial interstitialAd;
  AdmobReward rewardAd;

  void showSnackBar(String content) {
    scaffoldState.currentState.showSnackBar(
      SnackBar(
        content: Text(content),
        duration: Duration(milliseconds: 1500),
      ),
    );
  }

  void handleEvent(
      AdmobAdEvent event, Map<String, dynamic> args, String adType) {
    switch (event) {
      case AdmobAdEvent.loaded:
        showSnackBar('New Admob $adType Ad loaded!');
        break;
      case AdmobAdEvent.opened:
        showSnackBar('Admob $adType Ad opened!');
        break;
      case AdmobAdEvent.closed:
        showSnackBar('Admob $adType Ad closed!');
        break;
      case AdmobAdEvent.failedToLoad:
        showSnackBar('Admob $adType failed to load. :(');
        break;
      case AdmobAdEvent.rewarded:
        showDialog(
          context: scaffoldState.currentContext,
          builder: (BuildContext context) {
            return WillPopScope(
              child: AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('Reward callback fired. Thanks Andrew!'),
                    Text('Type: ${args['type']}'),
                    Text('Amount: ${args['amount']}'),
                  ],
                ),
              ),
              onWillPop: () async {
                scaffoldState.currentState.hideCurrentSnackBar();
                return true;
              },
            );
          },
        );
        break;
      default:
    }
  }

  void initState() {


    bannerSize = AdmobBannerSize.BANNER;

    interstitialAd = AdmobInterstitial(
      adUnitId: getInterstitialAdUnitId(),
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.closed) interstitialAd.load();
        handleEvent(event, args, 'Interstitial');
      },
    );

    rewardAd = AdmobReward(
      adUnitId: getRewardBasedVideoAdUnitId(),
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.closed) rewardAd.load();
        handleEvent(event, args, 'Reward');
      },
    );

    interstitialAd.load();
    rewardAd.load();

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
    interstitialAd.dispose();
    rewardAd.dispose();
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

        receviedChannelsViewModel.setSeletedTrue();

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

      receviedChannelsViewModel.setSeletedTrue();

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
      backgroundColor: Colors.pink[200],
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
                          child: Center(child: Text("add".tr().toString()))))),
            ],
          ),
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('title'.tr().toString()),
          GestureDetector(
            onTap: () async {
              isLoading.add(true);

              var shareItemViewModel =
                  Provider.of<SelectShareItemViewModel>(context, listen: false);

              shareItemViewModel.categories = categories;

              for (var category in categories) {
                category.selected = true;
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
      String newCategoryTitle = await showTextFieldDialog(context,
          title: "addCategory".tr().toString(),
          description: "addCategoryDesc".tr().toString());

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
            return category.lengthOfChannel < 1
                ? Info()
                : Column(
                  children: [
                    ChannelList(
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
                      ),
                    Container(
                      color: Colors.yellow,
                      child: AdmobBanner(
                        adUnitId: getBannerAdUnitId(),
                        adSize: bannerSize,
                        listener: (AdmobAdEvent event,
                            Map<String, dynamic> args) {
                          handleEvent(event, args, 'Banner');
                        },
                        onBannerCreated:
                            (AdmobBannerController controller) {
                          // Dispose is called automatically for you when Flutter removes the banner from the widget tree.
                          // Normally you don't need to worry about disposing this yourself, it's handled.
                          // If you need direct access to dispose, this is your guy!
                          // controller.dispose();
                        },
                      ),
                    ),
                  ],
                );
          }),
          Center(
              child: InkWell(
                  onTap: () async {
                    isLoading.add(true);
                    await addNewCategory(context);
                    isLoading.add(false);
                  },
                  child: BlickingBorderButton(
                      title: "add".tr().toString(), width: 150, height: 100))),
        ],
      ),
    );
  }

  Future<void> addNewCategory(BuildContext context) async {
    HomeViewModel _homeViewModel =
        Provider.of<HomeViewModel>(context, listen: false);
    List<Category> categories = _homeViewModel.categories;

    String newCategoryTitle = await showTextFieldDialog(context,
        title: "addCategory".tr().toString(),
        description: "addCategoryDesc".tr().toString());

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

class Info extends StatefulWidget {
  const Info({
    Key key,
  }) : super(key: key);

  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> with SingleTickerProviderStateMixin {
  AnimationController _resizableController;

  @override
  void initState() {
    _resizableController = new AnimationController(
      vsync: this,
      duration: new Duration(
        milliseconds: 600,
      ),
    );
    _resizableController.addStatusListener((animationStatus) {
      switch (animationStatus) {
        case AnimationStatus.completed:
          _resizableController.reverse();
          break;
        case AnimationStatus.dismissed:
          _resizableController.forward();
          break;
        case AnimationStatus.forward:
          break;
        case AnimationStatus.reverse:
          break;
      }
    });
    _resizableController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.width * 0.8 * (640 / 551),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.fitWidth,
                          image: NetworkImage(
                              "https://wonpyojang.github.io/TubeShakerHosting/images/youtube_share_flutter.png")))),
              SizedBox(height: 20),
              GestureDetector(
                  onTap: () async {
                    if (Platform.isAndroid) {
                      launch("https://www.youtube.com/");
                    } else {}
                  },
                  child: BlickingBorderButton(
                      title: "goToYoutube".tr().toString(),
                      width: 200,
                      height: 75)),
            ],
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 260,
                    color: Colors.black.withOpacity(0.3)),
                Row(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: 50,
                        color: Colors.black.withOpacity(0.3)),
                    Expanded(child: Container()),
                    Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: 50,
                        color: Colors.black.withOpacity(0.3))
                  ],
                ),
                Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 80,
                    color: Colors.black.withOpacity(0.3)),
              ],
            ),
          ),
        ),
        FadeTransition(
          opacity: _resizableController,
          child: Align(
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 200),
                Align(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.arrow_downward_rounded,
                      size: 40,
                      color: Colors.pink,
                    )),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class BlickingBorderButton extends StatefulWidget {
  const BlickingBorderButton({
    Key key,
    this.title,
    this.width,
    this.height,
  }) : super(key: key);
  final String title;
  final double width;
  final double height;

  @override
  _BlickingBorderButtonState createState() => _BlickingBorderButtonState();
}

class _BlickingBorderButtonState extends State<BlickingBorderButton>
    with SingleTickerProviderStateMixin {
  AnimationController _resizableController;

  @override
  void initState() {
    _resizableController = new AnimationController(
      vsync: this,
      duration: new Duration(
        milliseconds: 600,
      ),
    );
    _resizableController.addStatusListener((animationStatus) {
      switch (animationStatus) {
        case AnimationStatus.completed:
          _resizableController.reverse();
          break;
        case AnimationStatus.dismissed:
          _resizableController.forward();
          break;
        case AnimationStatus.forward:
          break;
        case AnimationStatus.reverse:
          break;
      }
    });
    _resizableController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _resizableController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _resizableController,
        builder: (context, snapshot) {
          return Container(
            width: widget.width,
            height: widget.height,
            child: Center(
                child: Text(widget.title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20.0))),
            decoration: BoxDecoration(
                color: Colors.pink[100],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                    width: 2 + _resizableController.value * 3,
                    color: Colors.pink[300])),
          );
        });
  }
}

String getBannerAdUnitId({bool isTest = true}) {
  String testAdId = "ca-app-pub-3940256099942544/6300978111";
  if (Platform.isIOS) {
    return isTest ? 'ca-app-pub-3940256099942544/6300978111' : 'ca-app-pub-3940256099942544/2934735716';
  } else if (Platform.isAndroid) {
    return isTest ? 'ca-app-pub-3940256099942544/6300978111' : 'ca-app-pub-2791028683117450/7394675022';
  }
  return null;
}

String getInterstitialAdUnitId() {
  if (Platform.isIOS) {
    return 'ca-app-pub-3940256099942544/4411468910';
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-3940256099942544/1033173712';
  }
  return null;
}

String getRewardBasedVideoAdUnitId() {
  if (Platform.isIOS) {
    return 'ca-app-pub-3940256099942544/1712485313';
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-3940256099942544/5224354917';
  }
  return null;
}
