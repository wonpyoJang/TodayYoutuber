import 'package:TodayYoutuber/common/dialogs.dart';
import 'package:TodayYoutuber/models/category.dart';
import 'package:TodayYoutuber/pages/home/home_view_model.dart';
import 'package:TodayYoutuber/pages/home/widget/bottom_sheet_for_adding_channel.dart';
import 'package:TodayYoutuber/pages/home/widget/channel_list.dart';
import 'package:TodayYoutuber/pages/home/widget/text_field_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:TodayYoutuber/main.dart';

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
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        showModalBttomShsetForAddingChannel(context, url);
      });
    });
    _homeViewModel.getUrlWhenStartedBySharingIntent((url) {
      showModalBttomShsetForAddingChannel(context, url);
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
      bottom: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabs: [
          ...categories.map((category) {
            final categoryIndex = categories.indexOf(category);
            return Tab(
                child: GestureDetector(
                    onLongPress: () async {
                      String newCategoryTitle =
                          await showTextFieldDialog(context);

                      if (newCategoryTitle == null) {
                        return;
                      }

                      DBAccessResult result = await _homeViewModel
                          .setCategoryTitle(categoryIndex, newCategoryTitle);
                      if (result == DBAccessResult.FAIL) {
                        showDBConnectionFailDailog(context);
                        return;
                      }

                      setState(() {});
                    },
                    child: Container(child: Text(category.title))));
          }),
          Tab(
              child: InkWell(
                  onTap: () => addNewCategory(context),
                  child: Container(child: Text("+ 추가하기")))),
        ],
      ),
      title: Text('유랭카'),
    );
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
