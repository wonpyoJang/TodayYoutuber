import 'package:TodayYoutuber/app.dart';
import 'package:TodayYoutuber/database/database.dart';
import 'package:flutter/material.dart';

import 'package:logger/logger.dart';
import 'package:rxdart/subjects.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:easy_localization/easy_localization.dart';

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
  runApp(EasyLocalization(
      supportedLocales: [Locale('en', 'US'), Locale('ko', 'KR')],
      path: 'assets/translations',
      fallbackLocale: Locale('en', 'US'),
      child: MyApp()));
}
