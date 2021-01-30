import 'package:TodayYoutuber/pages/home/home_view_model.dart';
import 'package:TodayYoutuber/pages/home/widget/channel_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChannelList extends StatelessWidget {
  final int categoryIndex;

  const ChannelList({
    Key key,
    this.categoryIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("[build] channelList");
    final vm = Provider.of<HomeViewModel>(context);
    return ListView.separated(
      itemCount: vm.getLengthOfChannels(0),
      separatorBuilder: (context, index) {
        return Container(height: 1.0, color: Colors.grey);
      },
      itemBuilder: (BuildContext context, int index) {
        return ChannelItem(categoryIndex: categoryIndex, channelIndex: index);
      },
    );
  }
}
