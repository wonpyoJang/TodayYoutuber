import 'package:flutter/material.dart';

import 'package:TodayYoutuber/main.dart';
import 'package:TodayYoutuber/models/category.dart';
import 'package:TodayYoutuber/pages/home/widget/channel_item.dart';

class ChannelList extends StatelessWidget {
  final Function onTapDeleteButton;
  final Category category;
  final bool disableScroll;
  final bool isSelectable;
  final Function onSelectChannel;
  const ChannelList(
      {Key key,
      this.onTapDeleteButton,
      this.category,
      this.disableScroll = false,
      this.isSelectable = false,
      this.onSelectChannel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    logger.d("[build] channelList");

    return ListView.separated(
      physics: disableScroll
          ? NeverScrollableScrollPhysics()
          : BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: category.lengthOfChannel,
      separatorBuilder: (context, index) {
        return Container(height: 1.0, color: Colors.grey);
      },
      itemBuilder: (BuildContext context, int index) {
        return ChannelItem(
            isSelectable: isSelectable,
            channel: category.channels[index],
            onSelectChannel: onSelectChannel,
            onTapDelete: () async {
              onTapDeleteButton(index);
            });
      },
    );
  }
}
