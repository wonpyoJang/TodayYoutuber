import 'dart:async';

import 'package:TodayYoutuber/common/route_manager.dart';
import 'package:TodayYoutuber/global.dart';
import 'package:TodayYoutuber/pages/home/home.dart';
import 'package:TodayYoutuber/pages/home/home_view_model.dart';
import 'package:TodayYoutuber/pages/received_channels/recevied_channels_view_model.dart';
import 'package:TodayYoutuber/pages/select_share_item/select_share_item_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // ignore: unused_field
  // ignore: cancel_subscriptions
  StreamSubscription _intentDataStreamSubscription;
  // ignore: unused_field
  Future<void> _initializeFlutterFireFuture;

  @override
  void initState() {
    _initializeFlutterFireFuture = _initializeFlutterFire();
    precacheImage(NetworkImage(
        "https://wonpyojang.github.io/TubeShakerHosting/images/youtube_share_flutter.png"), context);
    super.initState();
    this._intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String value) {
      if (value == null || value.isEmpty) return;
      isLoading.add(true);
      print("url listend");
      urlReceivedEvent.add(value);
    }, onError: (err) {
      logger.d("getLinkStream error: $err");
    });
  }

  // Define an async function to initialize FlutterFire
  Future<void> _initializeFlutterFire() async {
    // Wait for Firebase to initialize
    await Firebase.initializeApp();

    await FirebaseCrashlytics.instance
          .setCrashlyticsCollectionEnabled(!kDebugMode);
    // Pass all uncaught errors to Crashlytics.
    Function originalOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails errorDetails) async {
      await FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
      // Forward to original handler.
      originalOnError(errorDetails);
    };
  }

  @override
  void dispose() {
    super.dispose();
    this._intentDataStreamSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    logger.d("[build] MyApp");
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => HomeViewModel(),
        ),
        ChangeNotifierProvider(
            create: (context) => ReceivedChannelsViewModel()),
        ChangeNotifierProvider(create: (context) => SelectShareItemViewModel())
      ],
      child: MaterialApp(
        title: 'title'.tr().toString(),
        home: HomeScreen(),
        theme: ThemeData(
          primarySwatch: Colors.pink,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        onGenerateRoute: RouteManager.namesToScreen,
        localizationsDelegates: context.localizationDelegates,
        locale: context.locale,
        supportedLocales: context.supportedLocales,
      ),
    );
  }
}
