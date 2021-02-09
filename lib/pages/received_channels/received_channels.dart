import 'package:TodayYoutuber/models/share_event.dart';
import 'package:TodayYoutuber/models/user.dart';
import 'package:TodayYoutuber/pages/received_channels/recevied_channels_view_model.dart';
import 'package:TodayYoutuber/pages/received_channels/widget/category_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReceivedChannelsArgument {
  final ShareEvent sharedEvent;
  ReceivedChannelsArgument({this.sharedEvent});
}

class ReceivedChannelsScreen extends StatefulWidget {
  final ReceivedChannelsArgument args;

  ReceivedChannelsScreen({this.args});

  @override
  _ReceivedChannelsScreenState createState() => _ReceivedChannelsScreenState();
}

class _ReceivedChannelsScreenState extends State<ReceivedChannelsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var receivedChannelListViewModel =
        Provider.of<ReceivedChannelsViewModel>(context);
    User user = receivedChannelListViewModel.sharedEvent.user;
    var categories = receivedChannelListViewModel.sharedEvent.categories;

    return Scaffold(
        appBar: AppBar(
            title: Text("${user.username}(${user.jobTitle})이 공유한 채널 리스트")),
        body: CategoryList(
          categories: categories,
        ));
  }
}
