import 'package:TodayYoutuber/pages/home/widget/channel_list.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            print("HomeScreen, onPressed in FAB Add");
          },
          child: Icon(Icons.add)),
      body: ChannelList(),
    );
  }
}
