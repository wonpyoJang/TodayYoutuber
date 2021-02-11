import 'package:TodayYoutuber/models/category.dart';
import 'package:TodayYoutuber/models/channel.dart';
import 'package:TodayYoutuber/models/share_event.dart';
import 'package:TodayYoutuber/pages/received_channels/widget/category_list.dart';
import 'package:TodayYoutuber/pages/select_share_item/select_share_item_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectShareItemArgument {
  final ShareEvent sharedEvent;
  SelectShareItemArgument({this.sharedEvent});
}

class SelectShareItemScreen extends StatefulWidget {
  SelectShareItemScreen({Key key, this.args}) : super(key: key);

  final SelectShareItemArgument args;

  @override
  _SelectShareItemScreenState createState() => _SelectShareItemScreenState();
}

class _SelectShareItemScreenState extends State<SelectShareItemScreen> {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SelectShareItemViewModel>(context);
    return Scaffold(
        appBar: AppBar(title: Text("공유하기")),
        body: Container(
            child: CategoryList(
                categories: viewModel.categories,
                onSelectCategory: (Category category) {
                  if (category.selected) {
                    category.selected = false;
                    category.channels.forEach((channel) {
                      channel.selected = false;
                    });
                  } else {
                    category.selected = true;
                    category.channels.forEach((channel) {
                      channel.selected = true;
                    });
                  }
                  setState(() {});
                },
                onSelectChannel: (Channel channel) {
                  if (channel.selected) {
                    channel.selected = false;
                  } else {
                    channel.selected = true;
                  }
                  setState(() {});
                })));
  }
}
