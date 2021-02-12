import 'package:TodayYoutuber/common/dialogs.dart';
import 'package:TodayYoutuber/models/category.dart';
import 'package:TodayYoutuber/models/channel.dart';
import 'package:TodayYoutuber/pages/home/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:TodayYoutuber/main.dart';
import 'package:rxdart/rxdart.dart';

Future<int> showModalBttomShsetForAddingChannel(
    BuildContext context, String value) async {
  assert(value != null && value.isNotEmpty);
  if (value == null) {
    return null;
  }
  Channel parsedChannel = await _parseChannelYoutbue(value);
  BehaviorSubject<int> selectedCategoryStream = BehaviorSubject<int>();

  await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: Container(
            height: 400,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                SizedBox(height: 20),
                Text("채널 추가하기", style: TextStyle(fontSize: 25)),
                SizedBox(height: 10),
                _TextField(tag: "url", value: parsedChannel.link),
                SizedBox(height: 15),
                _TextField(tag: "채널명", value: parsedChannel.name),
                SizedBox(height: 15),
                _TextField(tag: "구독자수", value: parsedChannel.subscribers),
                SizedBox(height: 10),
                _SelectionBox(
                    tag: "분류", selectedCategoryStream: selectedCategoryStream),
                SizedBox(height: 50),
                _AddButton(
                    parsedChannel: parsedChannel,
                    selectedCategoryStream: selectedCategoryStream),
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
      });

  int selectedCategoryIndex = selectedCategoryStream.value;
  selectedCategoryStream.close();
  return selectedCategoryIndex;
}

class _AddButton extends StatelessWidget {
  const _AddButton(
      {Key key,
      @required this.parsedChannel,
      @required this.selectedCategoryStream})
      : super(key: key);

  final Channel parsedChannel;
  final BehaviorSubject<int> selectedCategoryStream;

  @override
  Widget build(BuildContext context) {
    final _homeViewModel = Provider.of<HomeViewModel>(context);
    return StreamBuilder<int>(
        stream: selectedCategoryStream.stream,
        builder: (context, selectedCategoryIndexSnapshot) {
          return GestureDetector(
              onTap: () async {
                DBAccessResult result = await _homeViewModel.addChannel(
                    selectedCategoryIndexSnapshot.data, parsedChannel);

                if (result == DBAccessResult.DUPLICATED_CHANNEL) {
                  await showDuplicatedChannelDailog(context);
                  return;
                } else if (result == DBAccessResult.FAIL) {
                  await showDBConnectionFailDailog(context);
                  return;
                }

                Navigator.of(context).pop();
              },
              child: Container(
                  width: 100,
                  height: 44,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      border: Border.all(width: 1, color: Colors.black)),
                  child: Center(child: Text("추가"))));
        });
  }
}

class _TextField extends StatelessWidget {
  final String tag;
  final String value;

  const _TextField({Key key, this.tag, this.value}) : super(key: key);

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
  String value = "선택하기";

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
