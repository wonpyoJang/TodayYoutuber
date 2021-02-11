import 'dart:async';

import 'package:TodayYoutuber/common/route_manager.dart';
import 'package:TodayYoutuber/database/database.dart';
import 'package:TodayYoutuber/pages/home/home.dart';
import 'package:TodayYoutuber/pages/home/home_view_model.dart';
import 'package:TodayYoutuber/pages/received_channels/recevied_channels_view_model.dart';
import 'package:TodayYoutuber/pages/select_share_item/select_share_item_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:logger/logger.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:rxdart/subjects.dart';
import 'package:firebase_database/firebase_database.dart';

final PublishSubject<String> urlReceivedEvent = PublishSubject<String>();

var logger = Logger(
  printer: PrettyPrinter(),
);

var loggerNoStack = Logger(
  printer: PrettyPrinter(methodCount: 0),
);

MyDatabase database;
final databaseReference = FirebaseDatabase.instance.reference();

final isLoading = BehaviorSubject<bool>();

void main() {
  database = MyDatabase();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // ignore: unused_field
  // ignore: cancel_subscriptions
  StreamSubscription _intentDataStreamSubscription;

  @override
  void initState() {
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
        title: 'Flutter Demo',
        home: HomeScreen(),
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        onGenerateRoute: RouteManager.namesToScreen,
      ),
    );
  }
}
