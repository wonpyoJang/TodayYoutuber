import 'package:TodayYoutuber/common/dialogs.dart';
import 'package:TodayYoutuber/pages/home/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:TodayYoutuber/main.dart';

class ChannelItem extends StatelessWidget {
  const ChannelItem({
    Key key,
    @required this.categoryIndex,
    @required this.channelIndex,
  }) : super(key: key);

  final int categoryIndex;
  final int channelIndex;

  @override
  Widget build(BuildContext context) {
    logger.d("[build] ChannelItem");
    assert(channelIndex != null && channelIndex >= 0);

    final _homeViewModel = Provider.of<HomeViewModel>(context);
    final channel = _homeViewModel.getChannels(categoryIndex)[channelIndex];

    assert(channel != null);

    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.15,
      child: InkWell(
        onTap: () async {
          channel.openUrlWithInappBrowser();
        },
        child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 15.0,
            ),
            child: Row(
              children: [
                _ThumbNail(
                  categoryIndex: categoryIndex,
                  channelIndex: channelIndex,
                ),
                SizedBox(width: 10),
                _Body(categoryIndex: categoryIndex, channelIndex: channelIndex),
                Expanded(child: SizedBox()),
                _LikeButton(
                  categoryIndex: categoryIndex,
                  channelIndex: channelIndex,
                ),
                SizedBox(width: 15)
              ],
            )),
      ),
      actions: <Widget>[],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: '삭제',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () async {
            var result =
                await _homeViewModel.deleteChannel(categoryIndex, channel);

            if (result == DBAccessResult.FAIL) {
              showDBConnectionFailDailog(context);
            }
          },
        ),
      ],
    );
  }
}

class _LikeButton extends StatelessWidget {
  const _LikeButton({
    Key key,
    @required this.categoryIndex,
    @required this.channelIndex,
  }) : super(key: key);

  final int categoryIndex;
  final int channelIndex;

  @override
  Widget build(BuildContext context) {
    assert(channelIndex != null && channelIndex >= 0);

    final vm = Provider.of<HomeViewModel>(context);
    final channel = vm.getChannels(categoryIndex)[channelIndex];

    assert(channel != null);

    return GestureDetector(
        onTap: () {
          logger.d("[touch event] like button");
          vm.toggleLike(0, channelIndex);
        },
        child: Container(
            child: Icon(channel.isLike
                ? Icons.favorite_rounded
                : Icons.favorite_border)));
  }
}

class _Body extends StatelessWidget {
  const _Body({
    Key key,
    @required this.categoryIndex,
    @required this.channelIndex,
  }) : super(key: key);

  final int categoryIndex;
  final int channelIndex;

  @override
  Widget build(BuildContext context) {
    assert(channelIndex != null && channelIndex >= 0);

    final vm = Provider.of<HomeViewModel>(context);
    final channel = vm.getChannels(categoryIndex)[channelIndex];

    assert(channel != null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(channel.name),
        Text("${channel.subscribers}", style: TextStyle(fontSize: 10))
      ],
    );
  }
}

class _ThumbNail extends StatelessWidget {
  const _ThumbNail({
    Key key,
    @required this.categoryIndex,
    @required this.channelIndex,
  }) : super(key: key);

  final int categoryIndex;
  final int channelIndex;

  @override
  Widget build(BuildContext context) {
    assert(channelIndex != null && channelIndex >= 0);

    final vm = Provider.of<HomeViewModel>(context);
    final channel = vm.getChannels(categoryIndex)[channelIndex];

    assert(vm != null);
    assert(channel != null);

    return CircleAvatar(
      backgroundImage: NetworkImage(channel.image),
    );
  }
}
