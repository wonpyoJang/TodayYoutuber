import 'package:TodayYoutuber/models/share_event.dart';
import 'package:TodayYoutuber/models/user.dart';
import 'package:flutter/material.dart';

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
    User user = widget.args.sharedEvent.user;
    return Scaffold(
      appBar:
          AppBar(title: Text("${user.username}(${user.jobTitle})이 공유한 채널 리스트")),
    );
  }
}
