import 'package:TodayYoutuber/common/loading_overlay.dart';
import 'package:TodayYoutuber/env/environment.dart';
import 'package:TodayYoutuber/global.dart';
import 'package:TodayYoutuber/models/category.dart';
import 'package:TodayYoutuber/models/channel.dart';
import 'package:TodayYoutuber/models/share_event.dart';
import 'package:TodayYoutuber/models/user.dart';
import 'package:TodayYoutuber/pages/home/widget/text_field_dialog.dart';
import 'package:TodayYoutuber/pages/received_channels/widget/category_list.dart';
import 'package:TodayYoutuber/pages/select_share_item/select_share_item_view_model.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:easy_localization/easy_localization.dart';

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
  bool isShareTappedFlag = false;

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SelectShareItemViewModel>(context);
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.pink[200],
          title: Text("share".tr().toString())),
      body: LoadingOverlay(
        child: Container(
          child: CategoryList(
              enableGoToYoutube: false,
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
              }),
        ),
      ),
      bottomNavigationBar: Builder(builder: (context) {
        return GestureDetector(
          onTap: () async {
            var numberOfSharedItem = viewModel.numberOfSelectedItem();
            if (numberOfSharedItem < 1) {
              final snackBar = SnackBar(
                  content: Text('noSelectedChannelError'.tr().toString()));
              Scaffold.of(context).showSnackBar(snackBar);
              return;
            }

            if (isShareTappedFlag == true) {
              return;
            }

            isShareTappedFlag = true;
            isLoading.add(true);

            String name = await showTextFieldDialog(context,
                title: "이름 입력", description: "공유 링크에 표시할 이름을 입력해주세요!");

            if (name == null || name.isEmpty) {
              isLoading.add(false);
              isShareTappedFlag = false;
              return;
            }

            String shareKey =
                "$name" + DateTime.now().millisecondsSinceEpoch.toString();

            final DynamicLinkParameters parameters = DynamicLinkParameters(
              uriPrefix: Environment.dynamicLinkUrl,
              link: Uri.parse(
                  '${Environment.dynamicLinkUrl}?shareKey=' + shareKey),
              androidParameters: AndroidParameters(
                packageName: Environment.packageName,
                minimumVersion: 1,
              ),
              iosParameters: IosParameters(
                bundleId: 'com.example.TodayYoutuber',
                minimumVersion: '1.0.1',
                appStoreId: '123456789',
              ),
              googleAnalyticsParameters: GoogleAnalyticsParameters(
                campaign: 'example-promo',
                medium: 'social',
                source: 'orkut',
              ),
              itunesConnectAnalyticsParameters:
                  ItunesConnectAnalyticsParameters(
                providerToken: '123456',
                campaignToken: 'example-promo',
              ),
              socialMetaTagParameters: SocialMetaTagParameters(
                title: '$name님의 유튜브 구독목록을 확인해보세요!',
                description: '$name님의 유튜브 구독목록을 확인해보세요!',
              ),
            );

            final ShortDynamicLink shortDynamicLink =
                await parameters.buildShortLink();
            final Uri shortUrl = shortDynamicLink.shortUrl;

            var shareEvent = ShareEvent(
                url: shortUrl.toString(),
                user: User(username: "$name", jobTitle: ""),
                categories: viewModel.categories);

            shareEvent.categories = shareEvent.getSeletecChannels();

            logger.d(shareEvent.toJson());

            var shareEventJosn = shareEvent.toJson();

            try {
              await databaseReference.child(shareKey).set(shareEventJosn);
            } catch (e) {
              assert(false);
              return;
            }

            isLoading.add(false);
            isShareTappedFlag = false;

            await Share.share(shortUrl.toString());
          },
          child: Container(
              height: 65,
              color: Colors.pink[100],
              child: Center(
                  child: Text(
                      "share".tr().toString() +
                          " (${viewModel.numberOfSelectedItem()})",
                      style: TextStyle(
                          fontSize: 17.0, fontWeight: FontWeight.bold)))),
        );
      }),
    );
  }
}
