import 'package:TodayYoutuber/common/loading_overlay.dart';
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
import 'package:easy_localization/easy_localization.dart';

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
      appBar: AppBar(
          backgroundColor: Colors.pink[200],
          title:
              Text("${user.username}" + "sharedChannelListOf".tr().toString())),
      body: LoadingOverlay(
        child: CategoryList(
            enableGoToYoutube: false,
            categories: categories,
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
            }),
      ),
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
                    child: Text("exit".tr().toString()),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Builder(builder: (context) {
                return GestureDetector(
                  onTap: () async {
                    if (receivedChannelListViewModel.numberOfSelectedItem() <
                        1) {
                      final snackBar = SnackBar(
                          content:
                              Text('noSelectedChannelError'.tr().toString()));
                      Scaffold.of(context).showSnackBar(snackBar);
                      return;
                    }

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
                      setState(() {

                      });
                    }

                    for (var category in categories) {
                      for (Channel channel in category.channels) {
                        if (channel.selected) {
                          homeViewModel.addChannel(categoryIndex, channel);
                        }
                      }
                    }
                    setState(() {});

                    final snackBar = SnackBar(
                        content: Text('channelAddedMsg'.tr().toString()));
                    Scaffold.of(context).showSnackBar(snackBar);
                  },
                  child: Container(
                    color: Colors.green[200],
                    child: Center(
                      child: Text(
                          "add2".tr() + " (${receivedChannelListViewModel.numberOfSelectedItem()})"),
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
