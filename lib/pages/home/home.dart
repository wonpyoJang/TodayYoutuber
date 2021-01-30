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
    _tabController = TabController(
        length: _homeViewModel.categories.length + 1,
        vsync: this,
        initialIndex: 0);
    _homeViewModel.subscribeSharingIntent((url) {
      showModalBttomShsetForAddingChannel(context, url);
    });
  }

  @override
  void dispose() {
    logger.d("[dispse] HomeScreen");
    super.dispose();
    HomeViewModel _homeViewModel =
        Provider.of<HomeViewModel>(context, listen: false);
    _homeViewModel.unsubscribeSharingIntent();
  }

  @override
  Widget build(BuildContext context) {
    logger.d("[build] HomeScreen");

    HomeViewModel _homeViewModel =
        Provider.of<HomeViewModel>(context, listen: false);
    _homeViewModel.unsubscribeSharingIntent();

    return Scaffold(
      appBar: bildAppBar(_homeViewModel.categories),
      body: TabBarView(
        controller: _tabController,
        children: [
          ..._homeViewModel.categories.map((category) {
            final index = _homeViewModel.categories.indexOf(category);
            return CategoryView(categoryIndex: index);
          }),
          Center(
              child: InkWell(
                  onTap: () => addNewCategory(context, _homeViewModel),
                  child: Container(
                      width: 100, height: 100, child: Text("+ 추가하기")))),
        ],
      ),
    );
  }

  Future addNewCategory(
      BuildContext context, HomeViewModel _homeViewModel) async {
    String newCategoryTitle = await showTextFieldDialog(context);

    _homeViewModel.addCategory(Category(title: newCategoryTitle, channels: []));

    setState(() {
      _tabController = new TabController(
          vsync: this, length: _homeViewModel.categories.length + 1);
    });
  }

  AppBar bildAppBar(List<Category> categories) {
    HomeViewModel _homeViewModel =
        Provider.of<HomeViewModel>(context, listen: false);

    return AppBar(
      bottom: TabBar(
        controller: _tabController,
        tabs: [
          ...categories.map((category) {
            final categoryIndex = categories.indexOf(category);
            return Tab(
                child: GestureDetector(
                    onLongPress: () async {
                      String newCategoryTitle =
                          await showTextFieldDialog(context);

                      if (newCategoryTitle == null) return;

                      _homeViewModel.setCategoryTitle(
                          categoryIndex, newCategoryTitle);
                      setState(() {});
                    },
                    child: Container(child: Text(category.title))));
          }),
          Tab(
              child: InkWell(
                  onTap: () => addNewCategory(context, _homeViewModel),
                  child: Container(child: Text("+ 추가하기")))),
        ],
      ),
      title: Text('유랭카'),
    );
  }
}
