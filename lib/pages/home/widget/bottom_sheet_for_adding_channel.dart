import 'package:TodayYoutuber/pages/home/widget/channel_info_item.dart';
import 'package:TodayYoutuber/pages/home/widget/selection_box.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

import 'package:TodayYoutuber/global.dart';
import 'package:TodayYoutuber/models/channel.dart';
import 'package:TodayYoutuber/pages/home/widget/channel_item.dart';
import 'package:easy_localization/easy_localization.dart';

Future<int> showModalBttomSheetForAddingChanel(
    BuildContext context, String value, Function onTapAddButton) async {
  assert(value != null && value.isNotEmpty);
  if (value == null) {
    return null;
  }
  Channel parsedChannel = await _parseChannelYoutbue(value);
  BehaviorSubject<int> selectedCategoryStream = BehaviorSubject<int>();

  await showModalBttomSheetBase(context,
      child: Container(
        height: MediaQuery.of(context).size.height / 2,
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20),
            Text("addChannel".tr().toString(), style: TextStyle(fontSize: 25)),
            SizedBox(height: 20),
            ChannelInfoItem(tag: "url".tr().toString(), value: parsedChannel.link),
            SizedBox(height: 15),
            ChannelInfoItem(
                tag: "channelName".tr().toString(), value: parsedChannel.name),
            SizedBox(height: 15),
            ChannelInfoItem(
                tag: "numberOfSubscribers".tr().toString(),
                value: parsedChannel.subscribers),
            SizedBox(height: 10),
            SelectionBox(
                tag: "category".tr().toString(),
                selectedCategoryStream: selectedCategoryStream),
            SizedBox(height: 50),
            AddButton(
              onTapAddButton: () {
                onTapAddButton(selectedCategoryStream.value, parsedChannel);
              },
            ),
          ],
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(
                  20,
                ),
                topRight: Radius.circular(20))),
      ));

  int selectedCategoryIndex = selectedCategoryStream.value;
  selectedCategoryStream.close();
  return selectedCategoryIndex;
}

class ModalBttomSheetForReceivedChanelsArgument {
  final int categoryIndex;
  final bool isNewCateogry;
  final String newCategoryName;

  ModalBttomSheetForReceivedChanelsArgument(
      {this.categoryIndex, this.isNewCateogry, this.newCategoryName});
}

Future<ModalBttomSheetForReceivedChanelsArgument>
    showModalBttomSheetForReceivedChanels(BuildContext context) async {
  BehaviorSubject<int> selectedCategoryStream = BehaviorSubject<int>();
  TextEditingController newCategoryNameTextEditingController =
      TextEditingController();
  bool isNewCategory = false;

  await showModalBttomSheetBase(context,
      child: ModalBottomSheetForReceivedChannelsScreen(
        selectedCategoryStream: selectedCategoryStream,
        newCategoryNameTextEditingController:
            newCategoryNameTextEditingController,
        onTapIsSelectedNewCategory: (isNew) {
          isNewCategory = isNew;
        },
      ));

  int selectedCategoryIndex = selectedCategoryStream.value;
  selectedCategoryStream.close();

  return ModalBttomSheetForReceivedChanelsArgument(
      categoryIndex: selectedCategoryIndex,
      isNewCateogry: isNewCategory,
      newCategoryName: newCategoryNameTextEditingController.text);
}

class ModalBottomSheetForReceivedChannelsScreen extends StatefulWidget {
  const ModalBottomSheetForReceivedChannelsScreen({
    Key key,
    @required this.selectedCategoryStream,
    this.newCategoryNameTextEditingController,
    this.onTapIsSelectedNewCategory,
  }) : super(key: key);

  final BehaviorSubject<int> selectedCategoryStream;
  final TextEditingController newCategoryNameTextEditingController;
  final Function onTapIsSelectedNewCategory;

  @override
  _ModalBottomSheetForReceivedChannelsScreenState createState() =>
      _ModalBottomSheetForReceivedChannelsScreenState();
}

class _ModalBottomSheetForReceivedChannelsScreenState
    extends State<ModalBottomSheetForReceivedChannelsScreen>
    with TickerProviderStateMixin {
  bool isSelectedNewCategory = false;
  AnimationController categoryFieldController;
  Animation<double> categoryFieldAnimation;
  AnimationController newCategoryNameFieldController;
  Animation<double> newCategoryNameFieldAnimation;

  @override
  void initState() {
    super.initState();
    prepareAnimations();
  }

  ///Setting up the animation
  void prepareAnimations() {
    categoryFieldController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    categoryFieldAnimation = CurvedAnimation(
      parent: categoryFieldController,
      curve: Curves.fastOutSlowIn,
    );
    newCategoryNameFieldController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    newCategoryNameFieldAnimation = CurvedAnimation(
      parent: newCategoryNameFieldController,
      curve: Curves.fastOutSlowIn,
    );
    categoryFieldController.forward();
  }

  @override
  void dispose() {
    categoryFieldController.dispose();
    newCategoryNameFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20),
            Text("addChannel".tr().toString(), style: TextStyle(fontSize: 25)),
            SizedBox(height: 10),
            Row(
              children: [
                GestureDetector(
                    onTap: () {
                      if (isSelectedNewCategory) {
                        isSelectedNewCategory = false;
                      } else {
                        isSelectedNewCategory = true;
                      }
                      widget.onTapIsSelectedNewCategory(isSelectedNewCategory);
                      setState(() {});
                      if (isSelectedNewCategory) {
                        categoryFieldController.reverse();
                        newCategoryNameFieldController.forward();
                      } else {
                        categoryFieldController.forward();
                        newCategoryNameFieldController.reverse();
                      }
                    },
                    child: SelectButton(selected: isSelectedNewCategory)),
                SizedBox(width: 20),
                Text("addToNewCategory".tr().toString())
              ],
            ),
            SizedBox(height: 30),
            SizeTransition(
              axisAlignment: 1.0,
              sizeFactor: newCategoryNameFieldAnimation,
              child: ChannelInfoItem(
                tag: "newCategory".tr().toString(),
                value: "",
                enableTextField: true,
                textEditingController:
                    widget.newCategoryNameTextEditingController,
              ),
            ),
            SizeTransition(
              axisAlignment: 1.0,
              sizeFactor: categoryFieldAnimation,
              child: SelectionBox(
                  tag: "category".tr().toString(),
                  selectedCategoryStream: widget.selectedCategoryStream),
            ),
            SizedBox(height: 50),
            AddButton(
              onTapAddButton: () {},
            ),
          ],
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(
                  20,
                ),
                topRight: Radius.circular(20))),
      ),
    );
  }
}

Future<void> showModalBttomSheetBase(BuildContext context,
    {Widget child}) async {
  await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: child,
        );
      });
}

class AddButton extends StatelessWidget {
  const AddButton({Key key, @required this.onTapAddButton}) : super(key: key);

  final Function onTapAddButton;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          onTapAddButton();
          Navigator.of(context).pop();
        },
        child: Container(
            width: 100,
            height: 44,
            decoration: BoxDecoration(
                color: Colors.pink[100],
                borderRadius: BorderRadius.all(Radius.circular(8)),
                border: Border.all(width: 1, color: Colors.pink[300])),
            child: Center(
                child: Text("submit".tr().toString(),
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold)))));
  }
}

Future<Channel> _parseChannelYoutbue(String url) async {
  assert(url != null && url.isNotEmpty);

  http.Response response = await http.get(url);
  String html = response.body;

  String thumbnailLink = _parseBetweenPivots(html,
      pivot1: 'videoOwnerRenderer":{"thumbnail":{"thumbnails":[{"url":"',
      pivot2: '"');
  String channelName =
      _parseBetweenPivots(html, pivot1: '"author":"', pivot2: '"');
  String subscribers = _parseBetweenPivots(html,
      pivot1: '"subscriberCountText":{"simpleText":"', pivot2: '"},');

  assert(thumbnailLink != null && thumbnailLink.isNotEmpty);
  assert(channelName != null && channelName.isNotEmpty);
  assert(subscribers != null && subscribers.isNotEmpty);

  return Channel(
    name: channelName,
    image: thumbnailLink,
    subscribers: subscribers,
    link: url,
  );
}

String _parseBetweenPivots(String html, {String pivot1, String pivot2}) {
  assert(html != null && html.isNotEmpty);
  assert(pivot1 != null && pivot1.isNotEmpty);
  assert(pivot2 != null && pivot2.isNotEmpty);

  html = html.substring(html.indexOf(pivot1) + pivot1.length);
  html = html.substring(0, html.indexOf(pivot2));
  logger.d("parse result: " + html);

  assert(html != null && html.isNotEmpty);

  return html;
}
