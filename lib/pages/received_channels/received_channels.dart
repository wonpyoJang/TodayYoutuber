import 'package:TodayYoutuber/common/route_manager.dart';
import 'package:TodayYoutuber/models/category.dart';
import 'package:TodayYoutuber/models/channel.dart';
import 'package:TodayYoutuber/models/share_event.dart';
import 'package:TodayYoutuber/models/user.dart';
import 'package:TodayYoutuber/pages/home/home_view_model.dart';
import 'package:TodayYoutuber/pages/home/widget/bottom_sheet_for_adding_channel.dart';
import 'package:TodayYoutuber/pages/received_channels/recevied_channels_view_model.dart';
import 'package:TodayYoutuber/pages/received_channels/widget/category_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReceivedChannelsArgument {
  final ShareEvent sharedEvent;
  ReceivedChannelsArgument({this.sharedEvent});
}

class ReceivedChannelsScreen extends StatefulWidget {
  final ReceivedChannelsArgument args;

  ReceivedChannelsScreen({this.args});

  @override
  _ReceivedChannelsScreenState createState() => _ReceivedChannelsScreenState();
}

class _ReceivedChannelsScreenState extends State<ReceivedChannelsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var receivedChannelListViewModel =
        Provider.of<ReceivedChannelsViewModel>(context);
    User user = receivedChannelListViewModel.sharedEvent.user;
    var categories = receivedChannelListViewModel.sharedEvent.categories;

    return Scaffold(
      appBar:
          AppBar(title: Text("${user.username}(${user.jobTitle})이 공유한 채널 리스트")),
      body: CategoryList(
          categories: categories,
          onSelectCategory: (Category category) {
            if (category.selected) {
              category.selected = false;
            } else {
              category.selected = true;
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
          }),
      bottomNavigationBar: Container(
        height: 65,
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      RouteLists.home, (route) => false);
                },
                child: Container(
                  color: Colors.red[100],
                  child: Center(
                    child: Text("나가기"),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Builder(builder: (context) {
                return GestureDetector(
                  onTap: () async {
                    final ModalBttomSheetForReceivedChanelsArgument results =
                        await showModalBttomSheetForReceivedChanels(context);

                    final homeViewModel =
                        Provider.of<HomeViewModel>(context, listen: false);

                    int categoryIndex = results.isNewCateogry
                        ? homeViewModel.categories.length
                        : results.categoryIndex;

                    if (results.isNewCateogry) {
                      final newCategory = Category(
                          title: results.newCategoryName, channels: []);
                      await homeViewModel.addCategory(newCategory);
                    }

                    for (var category in categories) {
                      for (Channel channel in category.channels) {
                        if (channel.selected) {
                          homeViewModel.addChannel(categoryIndex, channel);
                        }
                      }
                    }
                    setState(() {});

                    final snackBar = SnackBar(content: Text('재생목록에 추가되었습니다.'));

// Find the Scaffold in the widget tree and use it to show a SnackBar.
                    Scaffold.of(context).showSnackBar(snackBar);
                  },
                  child: Container(
                    color: Colors.green[200],
                    child: Center(
                      child: Text("추가"),
                    ),
                  ),
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}
