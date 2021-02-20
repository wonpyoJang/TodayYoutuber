import 'dart:io';
import 'package:TodayYoutuber/pages/home/widget/blinking_border_button.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

class UsageGuide extends StatefulWidget {
  const UsageGuide({
    Key key,
  }) : super(key: key);

  @override
  _UsageGuideState createState() => _UsageGuideState();
}

class _UsageGuideState extends State<UsageGuide>
    with SingleTickerProviderStateMixin {
  AnimationController _resizableController;

  @override
  void initState() {
    _resizableController = new AnimationController(
      vsync: this,
      duration: new Duration(
        milliseconds: 600,
      ),
    );
    _resizableController.addStatusListener((animationStatus) {
      switch (animationStatus) {
        case AnimationStatus.completed:
          _resizableController.reverse();
          break;
        case AnimationStatus.dismissed:
          _resizableController.forward();
          break;
        case AnimationStatus.forward:
          break;
        case AnimationStatus.reverse:
          break;
      }
    });
    _resizableController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.width * 0.8 * (640 / 551),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.fitWidth,
                          image: NetworkImage(
                              "https://wonpyojang.github.io/TubeShakerHosting/images/youtube_share_flutter.png")))),
              SizedBox(height: 20),
              GestureDetector(
                  onTap: () async {
                    if (Platform.isAndroid) {
                      launch("https://www.youtube.com/");
                    } else {}
                  },
                  child: BlickingBorderButton(
                      title: "goToYoutube".tr().toString(),
                      width: 200,
                      height: 75)),
            ],
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 260,
                    color: Colors.black.withOpacity(0.3)),
                Row(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: 50,
                        color: Colors.black.withOpacity(0.3)),
                    Expanded(child: Container()),
                    Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: 50,
                        color: Colors.black.withOpacity(0.3))
                  ],
                ),
                Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 80,
                    color: Colors.black.withOpacity(0.3)),
              ],
            ),
          ),
        ),
        FadeTransition(
          opacity: _resizableController,
          child: Align(
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 200),
                Align(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.arrow_downward_rounded,
                      size: 40,
                      color: Colors.pink,
                    )),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
