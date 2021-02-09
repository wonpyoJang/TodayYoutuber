import 'package:TodayYoutuber/models/channel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ChannelItem extends StatelessWidget {
  const ChannelItem({Key key, @required this.channel, this.onTapDelete})
      : super(key: key);

  final Channel channel;
  final Function onTapDelete;

  @override
  Widget build(BuildContext context) {
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
                  channel: channel,
                ),
                SizedBox(width: 10),
                _Body(channel: channel),
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
            onTapDelete();
          },
        ),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({Key key, @required this.channel}) : super(key: key);

  final Channel channel;

  @override
  Widget build(BuildContext context) {
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
  const _ThumbNail({Key key, @required this.channel}) : super(key: key);

  final Channel channel;

  @override
  Widget build(BuildContext context) {
    assert(channel != null);

    return CircleAvatar(
      backgroundImage: NetworkImage(channel.image),
    );
  }
}
