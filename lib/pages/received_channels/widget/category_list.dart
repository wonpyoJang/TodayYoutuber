import 'package:TodayYoutuber/models/category.dart';
import 'package:TodayYoutuber/pages/received_channels/widget/category_item.dart';
import 'package:flutter/material.dart';
import 'package:TodayYoutuber/main.dart';

class CategoryList extends StatefulWidget {
  const CategoryList(
      {Key key, this.categories, this.onSelectCategory, this.onSelectChannel})
      : super(key: key);

  final List<Category> categories;
  final Function onSelectCategory;
  final Function onSelectChannel;

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  List<bool> expandStates;

  @override
  void initState() {
    super.initState();
    setState(() {
      expandStates = List.generate(widget.categories.length, (index) => true);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (expandStates == null) {
      return Container();
    }

    logger.d("[build] channelList");
    return ListView.separated(
      itemCount: widget.categories.length,
      separatorBuilder: (context, index) {
        return Container(height: 1.0, color: Colors.grey);
      },
      itemBuilder: (BuildContext context, int index) {
        return CategoryItem(
          onSelectCategory: widget.onSelectCategory,
          onSelectChannel: widget.onSelectChannel,
          category: widget.categories[index],
          expand: expandStates[index],
          onTapCategory: (expandController) {
            if (expandStates[index]) {
              expandStates[index] = false;
              expandController.reverse();
            } else {
              expandStates[index] = true;
              expandController.forward();
            }
          },
        );
      },
    );
  }
}
