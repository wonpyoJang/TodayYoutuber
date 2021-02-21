import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class AdmobKey {
  String ios;
  String android;

  AdmobKey({this.android, this.ios});
}

class AdmobManager {
  static AdmobKey bannerAdUnitId;

  static Future<void> loadAdmobKey({bool isTest = false}) async {
    String result;
    var parsed;

    try {
      if (false == isTest) {
        result = await rootBundle.loadString('assets/admob/id.json');
        parsed = json.decode(result);
      }
    } catch (_) {}

    if (isTest) {
      bannerAdUnitId =
          AdmobKey(android: 'ca-app-pub-3940256099942544/6300978111');
    } else {
      bannerAdUnitId = AdmobKey(android: parsed["BannerAdUnitId"]["android"]);
    }

    return;
  }

  static void handleEvent(GlobalKey<ScaffoldState> scaffoldState,
      AdmobAdEvent event, Map<String, dynamic> args, String adType) {
    switch (event) {
      case AdmobAdEvent.loaded:
        showSnackBar(scaffoldState, 'New Admob $adType Ad loaded!');
        break;
      case AdmobAdEvent.opened:
        showSnackBar(scaffoldState, 'Admob $adType Ad opened!');
        break;
      case AdmobAdEvent.closed:
        showSnackBar(scaffoldState, 'Admob $adType Ad closed!');
        break;
      case AdmobAdEvent.failedToLoad:
        showSnackBar(scaffoldState, 'Admob $adType failed to load. :(');
        break;
      case AdmobAdEvent.rewarded:
        showDialog(
          context: scaffoldState.currentContext,
          builder: (BuildContext context) {
            return WillPopScope(
              child: AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('Reward callback fired. Thanks Andrew!'),
                    Text('Type: ${args['type']}'),
                    Text('Amount: ${args['amount']}'),
                  ],
                ),
              ),
              onWillPop: () async {
                scaffoldState.currentState.hideCurrentSnackBar();
                return true;
              },
            );
          },
        );
        break;
      default:
    }
  }

  static void showSnackBar(
      GlobalKey<ScaffoldState> scaffoldState, String content) {
    scaffoldState.currentState.showSnackBar(
      SnackBar(
        content: Text(content),
        duration: Duration(milliseconds: 1500),
      ),
    );
  }

  static String getBannerAdUnitId({bool isTest = true}) {
    if (Platform.isIOS) {
      return isTest ? 'ca-app-pub-3940256099942544/6300978111' : '';
    } else if (Platform.isAndroid) {
      return AdmobManager.bannerAdUnitId.android;
    }
    return null;
  }

  static String getInterstitialAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/4411468910';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/1033173712';
    }
    return null;
  }

  static String getRewardBasedVideoAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/1712485313';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/5224354917';
    }
    return null;
  }
}
