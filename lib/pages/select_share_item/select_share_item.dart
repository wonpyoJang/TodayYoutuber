import 'package:TodayYoutuber/common/loading_overlay.dart';
import 'package:TodayYoutuber/main.dart';
import 'package:TodayYoutuber/models/category.dart';
import 'package:TodayYoutuber/models/channel.dart';
import 'package:TodayYoutuber/models/share_event.dart';
import 'package:TodayYoutuber/models/user.dart';
import 'package:TodayYoutuber/pages/received_channels/widget/category_list.dart';
import 'package:TodayYoutuber/pages/select_share_item/select_share_item_view_model.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

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
      appBar: AppBar(title: Text("공유하기")),
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
      bottomNavigationBar: GestureDetector(
        onTap: () async {
          if (isShareTappedFlag == true) {
            return;
          }
          isShareTappedFlag = true;
          isLoading.add(true);

          String shareKey =
              "kildong" + DateTime.now().millisecondsSinceEpoch.toString();

          // todo: 이 부분은 추후 다른 페이지로 옮길 예정이므로 viewModel로 따로 빼지 않습니다.
          final DynamicLinkParameters parameters = DynamicLinkParameters(
            uriPrefix: 'https://todayyoutuber.page.link',
            link: Uri.parse(
                'https://todayyoutuber.page.link?shareKey=' + shareKey),
            androidParameters: AndroidParameters(
              packageName: 'com.example.TodayYoutuber',
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
            itunesConnectAnalyticsParameters: ItunesConnectAnalyticsParameters(
              providerToken: '123456',
              campaignToken: 'example-promo',
            ),
            socialMetaTagParameters: SocialMetaTagParameters(
              title: '장원표(플러터 개발자)님의 유튜브 구독목록을 확인해보세요!',
              description: '장원표(플러터 개발자)님의 유튜브 구독목록을 확인해보세요!',
            ),
          );

          final ShortDynamicLink shortDynamicLink =
              await parameters.buildShortLink();
          final Uri shortUrl = shortDynamicLink.shortUrl;

          var shareEvent = ShareEvent(
              url: shortUrl.toString(),
              user: User(username: "장원표", jobTitle: "플러터개발자"),
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
            color: Colors.green[200],
            child: Center(
                child: Text("공유하기 (${viewModel.numberOfSelectedItem()})"))),
      ),
    );
  }
}
