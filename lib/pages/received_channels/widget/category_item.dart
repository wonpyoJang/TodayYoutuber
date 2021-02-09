import 'package:TodayYoutuber/models/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:TodayYoutuber/main.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({Key key, @required this.category}) : super(key: key);

  final Category category;
  @override
  Widget build(BuildContext context) {
    logger.d("[build] ChannelItem");

    return Slidable(
      enabled: false,
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.15,
      child:
          Container(height: 55.0, child: Center(child: Text(category.title))),
      actions: <Widget>[],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: '삭제',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () async {},
        ),
      ],
    );
  }
}
