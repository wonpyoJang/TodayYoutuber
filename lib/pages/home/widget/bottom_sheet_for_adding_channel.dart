import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import 'package:TodayYoutuber/common/dialogs.dart';
import 'package:TodayYoutuber/main.dart';
import 'package:TodayYoutuber/models/category.dart';
import 'package:TodayYoutuber/models/channel.dart';
import 'package:TodayYoutuber/pages/home/home_view_model.dart';
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
        height: 400,
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20),
            Text("addChannel".tr().toString(), style: TextStyle(fontSize: 25)),
            SizedBox(height: 10),
            _TextField(tag: "url".tr().toString(), value: parsedChannel.link),
            SizedBox(height: 15),
            _TextField(
                tag: "channelName".tr().toString(), value: parsedChannel.name),
            SizedBox(height: 15),
            _TextField(
                tag: "numberOfSubscribers".tr().toString(),
                value: parsedChannel.subscribers),
            SizedBox(height: 10),
            _SelectionBox(
                tag: "category".tr().toString(),
                selectedCategoryStream: selectedCategoryStream),
            SizedBox(height: 50),
            _AddButton(
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
              child: _TextField(
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
              child: _SelectionBox(
                  tag: "category".tr().toString(),
                  selectedCategoryStream: widget.selectedCategoryStream),
            ),
            SizedBox(height: 50),
            _AddButton(
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

class _AddButton extends StatelessWidget {
  const _AddButton({Key key, @required this.onTapAddButton}) : super(key: key);

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
                color: Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(8)),
                border: Border.all(width: 1, color: Colors.black)),
            child: Center(child: Text("submit".tr().toString()))));
  }
}

class _TextField extends StatelessWidget {
  final String tag;
  final String value;
  final bool enableTextField;
  final TextEditingController textEditingController;

  const _TextField(
      {Key key,
      this.tag,
      this.value,
      this.enableTextField = false,
      this.textEditingController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(4),
              height: 44,
              width: 70,
              alignment: Alignment.centerLeft,
              child: Text(tag),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(4)),
                border: Border.all(width: 1, color: Colors.black),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Stack(
                children: [
                  Container(
                      height: 44,
                      padding: EdgeInsets.all(4),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        value,
                        maxLines: 3,
                      ),
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          border: Border.all(width: 1, color: Colors.black))),
                  if (enableTextField)
                    TextField(
                      controller: textEditingController,
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectionBox extends StatefulWidget {
  final String tag;
  final BehaviorSubject<int> selectedCategoryStream;

  _SelectionBox({Key key, this.tag, this.selectedCategoryStream})
      : super(key: key);

  @override
  __SelectionBoxState createState() => __SelectionBoxState();
}

class __SelectionBoxState extends State<_SelectionBox> {
  String value = "selection".tr().toString();

  @override
  Widget build(BuildContext context) {
    HomeViewModel _homeViewModel = Provider.of(context, listen: false);
    List<Category> categories = _homeViewModel.categories;

    return GestureDetector(
      onTap: () async {
        // 초기값
        value = categories[0].title;
        widget.selectedCategoryStream.add(0);
        setState(() {});

        await showSelectFromCategories(context, categories,
            onSelect: (category) {
          value = category.title;
          widget.selectedCategoryStream.add(categories.indexOf(category));
          setState(() {});
        }, onSubmit: () {
          Navigator.of(context).pop();
        });
      },
      child: Container(
        child: Container(
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(4),
                height: 44,
                width: 70,
                alignment: Alignment.centerLeft,
                child: Text(widget.tag),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  border: Border.all(width: 1, color: Colors.black),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Container(
                    height: 44,
                    padding: EdgeInsets.all(4),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      value,
                      maxLines: 3,
                    ),
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        border: Border.all(width: 1, color: Colors.black))),
              ),
            ],
          ),
        ),
      ),
    );
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
