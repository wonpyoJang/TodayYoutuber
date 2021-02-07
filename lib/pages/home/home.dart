import 'package:TodayYoutuber/common/dialogs.dart';
import 'package:TodayYoutuber/models/category.dart';
import 'package:TodayYoutuber/models/share_event.dart';
import 'package:TodayYoutuber/models/user.dart';
import 'package:TodayYoutuber/pages/home/home_view_model.dart';
import 'package:TodayYoutuber/pages/home/widget/bottom_sheet_for_adding_channel.dart';
import 'package:TodayYoutuber/pages/home/widget/channel_list.dart';
import 'package:TodayYoutuber/pages/home/widget/text_field_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:TodayYoutuber/main.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:share/share.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  TabController _tabController;

  void initState() {
    logger.d("[initState] HomeScreen");
    super.initState();
    HomeViewModel _homeViewModel =
        Provider.of<HomeViewModel>(context, listen: false);

    urlReceivedEvent.stream.listen((url) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        int selectedCategoryIndex =
            await showModalBttomShsetForAddingChannel(context, url);
        _tabController.animateTo(selectedCategoryIndex);
      });
    });
    _homeViewModel.getUrlWhenStartedBySharingIntent((url) async {
      int selectedCategoryIndex =
          await showModalBttomShsetForAddingChannel(context, url);
      _tabController.animateTo(selectedCategoryIndex);
    });

    _tabController = TabController(
        length: _homeViewModel.categories.length + 1,
        vsync: this,
        initialIndex: 0);

    getDatasFromDB(context);
  }

  @override
  void dispose() {
    logger.d("[dispse] HomeScreen");
    super.dispose();
  }

  void getDatasFromDB(BuildContext context) async {
    HomeViewModel _homeViewModel =
        Provider.of<HomeViewModel>(context, listen: false);
    List<Category> categories = _homeViewModel.categories;

    await _homeViewModel.getCategoriesFromDB();
    await _homeViewModel.getChannelsFromDB();

    _tabController = TabController(vsync: this, length: categories.length + 1);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    logger.d("[build] HomeScreen");

    return Scaffold(
      appBar: bildAppBar(context),
      body: buildBody(context),
    );
  }

  Widget bildAppBar(BuildContext context) {
    HomeViewModel _homeViewModel =
        Provider.of<HomeViewModel>(context, listen: false);
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
                      onTap: () => addNewCategory(context),
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
              // todo: 이 부분은 추후 다른 페이지로 옮길 예정이므로 viewModel로 따로 빼지 않습니다.
              final DynamicLinkParameters parameters = DynamicLinkParameters(
                uriPrefix: 'https://todayyoutuber.page.link',
                link: Uri.parse('https://example.com/'),
                androidParameters: AndroidParameters(
                  packageName: 'com.example.TodayYoutuber',
                  minimumVersion: 1,
                ),
                iosParameters: IosParameters(
                  bundleId: 'com.example.TodayYoutuber',
                  minimumVersion: '1.0.1',
                  appStoreId: '123456789',
                ),
                googleAnalyticsParameters: GoogleAnalyticsParameters(
                  campaign: 'example-promo',
                  medium: 'social',
                  source: 'orkut',
                ),
                itunesConnectAnalyticsParameters:
                    ItunesConnectAnalyticsParameters(
                  providerToken: '123456',
                  campaignToken: 'example-promo',
                ),
                socialMetaTagParameters: SocialMetaTagParameters(
                  title: '장원표(플러터 개발자)님의 유튜브 구독목록을 확인해보세요!',
                  description: '장원표(플러터 개발자)님의 유튜브 구독목록을 확인해보세요!',
                ),
              );

              final ShortDynamicLink shortDynamicLink =
                  await parameters.buildShortLink();
              final Uri shortUrl = shortDynamicLink.shortUrl;

              var shareEvent = ShareEvent(
                  url: shortUrl.toString(),
                  user: User(username: "장원표", jobTitle: "플러터개발자"),
                  categories: categories);

              logger.d(shareEvent.toJson());
              var shareEventJosn = shareEvent.toJson();
              var firebaseDataKey = shortUrl.toString().split(".").join();

              try {
                await databaseReference
                    .child(firebaseDataKey)
                    .set(shareEventJosn);
              } catch (e) {
                assert(false);
                return;
              }

              await Share.share(shortUrl.toString());
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
        Provider.of<HomeViewModel>(context, listen: false);
    List<Category> categories = _homeViewModel.categories;

    return TabBarView(
      controller: _tabController,
      physics: NeverScrollableScrollPhysics(),
      children: [
        ...categories.map((category) {
          final index = categories.indexOf(category);
          return CategoryView(categoryIndex: index);
        }),
        Center(
            child: InkWell(
                onTap: () => addNewCategory(context),
                child:
                    Container(width: 100, height: 100, child: Text("+ 추가하기")))),
      ],
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
