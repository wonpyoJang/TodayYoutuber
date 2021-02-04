import 'dart:async';

import 'package:TodayYoutuber/database/database.dart';
import 'package:TodayYoutuber/pages/home/home.dart';
import 'package:TodayYoutuber/pages/home/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:logger/logger.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:rxdart/subjects.dart';

PublishSubject<String> urlReceivedEvent = PublishSubject<String>();

var logger = Logger(
  printer: PrettyPrinter(),
);

var loggerNoStack = Logger(
  printer: PrettyPrinter(methodCount: 0),
);

MyDatabase database;

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
  StreamSubscription _intentDataStreamSubscription;
  @override
  void initState() {
    super.initState();

    _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String value) {
      if (value == null || value.isEmpty) return;
      print("url listend");
      urlReceivedEvent.add(value);
    }, onError: (err) {
      logger.d("getLinkStream error: $err");
    });
  }

  @override
  void dispose() {
    super.dispose();
    _intentDataStreamSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    logger.d("[build] MyApp");
    return ChangeNotifierProvider(
      create: (context) => HomeViewModel(),
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: HomeScreen()),
    );
  }
}
