import 'package:TodayYoutuber/models/category.dart';
import 'package:TodayYoutuber/pages/received_channels/widget/category_item.dart';
import 'package:flutter/material.dart';
import 'package:TodayYoutuber/main.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({Key key, this.categories}) : super(key: key);

  final List<Category> categories;

  @override
  Widget build(BuildContext context) {
    logger.d("[build] channelList");
    return ListView.separated(
      itemCount: categories.length,
      separatorBuilder: (context, index) {
        return Container(height: 1.0, color: Colors.grey);
      },
      itemBuilder: (BuildContext context, int index) {
        return CategoryItem(
          category: categories[index],
        );
      },
    );
  }
}
