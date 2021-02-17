import 'package:TodayYoutuber/models/category.dart';
import 'package:TodayYoutuber/pages/home/widget/channel_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:TodayYoutuber/global.dart';

class CategoryItem extends StatefulWidget {
  const CategoryItem(
      {Key key,
      @required this.category,
      this.expand,
      this.onTapCategory,
      this.onSelectCategory,
      this.onSelectChannel,
      this.enableGoToYoutube = true})
      : super(key: key);

  final Category category;
  final Function onTapCategory;
  final bool expand;
  final Function onSelectCategory;
  final Function onSelectChannel;
  final bool enableGoToYoutube;

  @override
  _CategoryItemState createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem>
    with SingleTickerProviderStateMixin {
  AnimationController expandController;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    prepareAnimations();
    _runExpandCheck();
  }

  ///Setting up the animation
  void prepareAnimations() {
    expandController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    animation = CurvedAnimation(
      parent: expandController,
      curve: Curves.fastOutSlowIn,
    );
  }

  void _runExpandCheck() {
    if (widget.expand) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    logger.d("[build] ChannelItem");

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            widget.onTapCategory(expandController);
          },
          child: Slidable(
            enabled: false,
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.15,
            child: Container(
                color: widget.category.selected
                    ? Colors.grey[500]
                    : Colors.grey[400],
                height: 55.0,
                child: Stack(
                  children: [
                    Center(
                        child: Text(
                            widget.category.title +
                                " (${widget.category.selectedChannels})",
                            style: TextStyle(
                                fontSize: 15.0, fontWeight: FontWeight.bold))),
                    Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                            onTap: () {
                              widget.onSelectCategory(widget.category);
                            },
                            child: TotalSelectButton(
                                selected: widget.category.selected)))
                  ],
                )),
            actions: <Widget>[],
            secondaryActions: <Widget>[
              IconSlideAction(
                caption: '삭제',
                color: Colors.red,
                icon: Icons.delete,
                onTap: () async {},
              ),
            ],
          ),
        ),
        SizeTransition(
          axisAlignment: 1.0,
          sizeFactor: animation,
          child: ChannelList(
            isSlidable: false,
            enableGoToYoutube: widget.enableGoToYoutube,
            onSelectChannel: widget.onSelectChannel,
            isSelectable: true,
            category: widget.category,
            disableScroll: true,
            onTapDeleteButton: () {},
          ),
        )
      ],
    );
  }
}

class TotalSelectButton extends StatelessWidget {
  const TotalSelectButton({
    Key key,
    @required this.selected,
  }) : super(key: key);

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15.0),
      child: Container(
        height: 30,
        width: 30,
        child: Icon(Icons.check),
        decoration: BoxDecoration(
            color: this.selected ? Colors.yellow : Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(width: 1, color: Colors.orange)),
      ),
    );
  }
}
