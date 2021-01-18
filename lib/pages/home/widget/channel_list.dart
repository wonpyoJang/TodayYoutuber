import 'package:TodayYoutuber/pages/home/home_view_model.dart';
import 'package:TodayYoutuber/pages/home/widget/channel_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChannelList extends StatelessWidget {
  const ChannelList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<HomeViewModel>(context);
    return ListView.separated(
      itemCount: vm.lengthOfChannels,
      separatorBuilder: (context, index) {
        return Container(height: 1.0, color: Colors.grey);
      },
      itemBuilder: (BuildContext context, int index) {
        return ChannelItem(channelIndex: index);
      },
    );
  }
}
