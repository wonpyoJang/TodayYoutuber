import 'package:TodayYoutuber/pages/home/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChannelItem extends StatelessWidget {
  const ChannelItem({
    Key key,
    @required this.channelIndex,
  }) : super(key: key);

  final int channelIndex;

  @override
  Widget build(BuildContext context) {
    print("[build] ChannelItem");
    assert(channelIndex != null && channelIndex >= 0);

    final vm = Provider.of<HomeViewModel>(context);
    final channel = vm.getChannels(0)[channelIndex];

    assert(channel != null);

    return InkWell(
      onTap: () async {
        channel.openUrlWithInappBrowser();
      },
      child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 5.0,
          ),
          child: Row(
            children: [
              _ThumbNail(
                channelIndex: channelIndex,
              ),
              SizedBox(width: 10),
              _Body(channelIndex: channelIndex),
              Expanded(child: SizedBox()),
              _LikeButton(
                channelIndex: channelIndex,
              ),
              SizedBox(width: 15)
            ],
          )),
    );
  }
}

class _LikeButton extends StatelessWidget {
  const _LikeButton({
    Key key,
    @required this.channelIndex,
  }) : super(key: key);

  final int channelIndex;

  @override
  Widget build(BuildContext context) {
    assert(channelIndex != null && channelIndex >= 0);

    final vm = Provider.of<HomeViewModel>(context);
    final channel = vm.getChannels(0)[channelIndex];

    assert(channel != null);

    return GestureDetector(
        onTap: () {
          print("Home, build, like button, tappled");
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
    @required this.channelIndex,
  }) : super(key: key);

  final int channelIndex;

  @override
  Widget build(BuildContext context) {
    assert(channelIndex != null && channelIndex >= 0);

    final vm = Provider.of<HomeViewModel>(context);
    final channel = vm.getChannels(0)[channelIndex];

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
    @required this.channelIndex,
  }) : super(key: key);

  final int channelIndex;

  @override
  Widget build(BuildContext context) {
    assert(channelIndex != null && channelIndex >= 0);

    final vm = Provider.of<HomeViewModel>(context);
    final channel = vm.getChannels(0)[channelIndex];

    assert(vm != null);
    assert(channel != null);

    return CircleAvatar(
      backgroundImage: NetworkImage(channel.image),
    );
  }
}
