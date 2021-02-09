import 'package:TodayYoutuber/models/category.dart';
import 'package:TodayYoutuber/pages/home/widget/channel_item.dart';
import 'package:flutter/material.dart';
import 'package:TodayYoutuber/main.dart';

class ChannelList extends StatelessWidget {
  final Function onTapDeleteButton;
  final Category category;
  const ChannelList({Key key, this.category, this.onTapDeleteButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    logger.d("[build] channelList");

    return ListView.separated(
      itemCount: category.lengthOfChannel,
      separatorBuilder: (context, index) {
        return Container(height: 1.0, color: Colors.grey);
      },
      itemBuilder: (BuildContext context, int index) {
        return ChannelItem(
            channel: category.channels[index],
            onTapDelete: () async {
              onTapDeleteButton(index);
            });
      },
    );
  }
}
