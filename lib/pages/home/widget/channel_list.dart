import 'package:TodayYoutuber/pages/home/home_view_model.dart';
import 'package:TodayYoutuber/pages/home/widget/channel_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:TodayYoutuber/main.dart';

class CategoryView extends StatelessWidget {
  final int categoryIndex;

  const CategoryView({
    Key key,
    this.categoryIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logger.d("[build] channelList");
    final vm = Provider.of<HomeViewModel>(context);
    return ListView.separated(
      itemCount: vm.getLengthOfChannels(categoryIndex),
      separatorBuilder: (context, index) {
        return Container(height: 1.0, color: Colors.grey);
      },
      itemBuilder: (BuildContext context, int index) {
        return ChannelItem(categoryIndex: categoryIndex, channelIndex: index);
      },
    );
  }
}
