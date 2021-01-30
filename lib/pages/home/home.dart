import 'package:TodayYoutuber/pages/home/home_view_model.dart';
import 'package:TodayYoutuber/pages/home/widget/bottom_sheet_for_adding_channel.dart';
import 'package:TodayYoutuber/pages/home/widget/channel_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void initState() {
    print("[initState] HomeScreen");
    super.initState();
    HomeViewModel _homeViewModel =
        Provider.of<HomeViewModel>(context, listen: false);
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
    return Scaffold(
      body: ChannelList(),
    );
  }
}
