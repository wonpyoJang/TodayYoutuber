import 'package:TodayYoutuber/pages/home/home_view_model.dart';
import 'package:TodayYoutuber/pages/home/widget/bottom_sheet_for_adding_channel.dart';
import 'package:TodayYoutuber/pages/home/widget/channel_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  void initState() {
    print("[initState] HomeScreen");
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
    print("[dispse] HomeScreen");
    super.dispose();
    HomeViewModel _homeViewModel =
        Provider.of<HomeViewModel>(context, listen: false);
    _homeViewModel.unsubscribeSharingIntent();
  }

  @override
  Widget build(BuildContext context) {
    print("[build] HomeScreen");

    HomeViewModel _homeViewModel =
        Provider.of<HomeViewModel>(context, listen: false);
    _homeViewModel.unsubscribeSharingIntent();

    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            ..._homeViewModel.categories.map((category) {
              return Tab(child: Container(child: Text(category.title)));
            }),
            Tab(child: Container(child: Text("+ 추가하기"))),
          ],
        ),
        title: Text('유랭카'),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ..._homeViewModel.categories.map((category) {
            final index = _homeViewModel.categories.indexOf(category);
            return ChannelList(categoryIndex: index);
          }),
          Center(child: Text("+ 추가하기")),
        ],
      ),
    );
  }
}
