import 'dart:async';

import 'package:TodayYoutuber/app.dart';
import 'package:TodayYoutuber/common/admob.dart';
import 'package:TodayYoutuber/database/database.dart';
import 'package:TodayYoutuber/global.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

enum BuildType { development, production }

class Environment {
  static Environment _instance;

  static Environment get instance => _instance;

  final BuildType _buildType;

  static BuildType get buildType => instance._buildType;

  static String get apiUrl => instance._buildType == BuildType.development
      ? "https://dev.your-domain.com"
      : 'https://prod.your-domain.com';

  static String get dynamicLinkUrl =>
      instance._buildType == BuildType.development
          ? "https://todayyoutubedev.page.link"
          : "https://tubeshaker.page.link";

  static String get packageName => instance._buildType == BuildType.development
      ? "com.pinkbori.TubeShaker.dev"
      : "com.pinkbori.TubeShaker";

  const Environment._internal(this._buildType);

  factory Environment.newInstance(BuildType buildType) {
    assert(buildType != null);
    if (_instance == null) {
      _instance = Environment._internal(buildType);
    }
    return _instance;
  }

  bool get isDebuggable => _buildType == BuildType.development;

  void run() async {
    WidgetsFlutterBinding.ensureInitialized();
    Admob.initialize();
    await AdmobManager.loadAdmobKey(isTest: true);
    database = MyDatabase();

    runZonedGuarded(() {
      runApp(EasyLocalization(
          supportedLocales: [Locale('en', 'US'), Locale('ko', 'KR')],
          path: 'assets/translations',
          fallbackLocale: Locale('en', 'US'),
          child: MyApp()));
    }, (error, stackTrace) {
      print('runZonedGuarded: Caught error in my root zone.');
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
    });
  }
}
