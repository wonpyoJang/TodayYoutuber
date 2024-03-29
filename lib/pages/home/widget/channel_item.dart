import 'package:TodayYoutuber/models/channel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:url_launcher/url_launcher.dart';

class ChannelItem extends StatelessWidget {
  const ChannelItem(
      {Key key,
      @required this.channel,
      this.onTapDelete,
      this.isSelectable = false,
      this.onSelectChannel,
      this.enableGoToYoutube,
      this.isSlidable = true})
      : super(key: key);

  final Channel channel;
  final Function onTapDelete;
  final bool isSelectable;
  final Function onSelectChannel;
  final bool enableGoToYoutube;
  final bool isSlidable;

  @override
  Widget build(BuildContext context) {
    assert(channel != null);

    return Slidable(
      enabled: isSlidable,
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.15,
      child: InkWell(
        onTap: () async {
          if (enableGoToYoutube) {
            launch(channel.link);
          }
        },
        child: Container(
            color: isSelectable && channel.selected
                ? Colors.yellow[100]
                : Colors.white,
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
                Expanded(child: Container()),
                if (this.isSelectable)
                  GestureDetector(
                      onTap: () {
                        if (onSelectChannel != null) {
                          onSelectChannel(channel);
                        }
                      },
                      child: SelectButton(selected: channel.selected))
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

class SelectButton extends StatelessWidget {
  const SelectButton({
    Key key,
    @required this.selected,
  }) : super(key: key);

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 30,
      child: Icon(Icons.check),
      decoration: BoxDecoration(
          color: this.selected ? Colors.yellow : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(width: 1, color: Colors.orange)),
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
