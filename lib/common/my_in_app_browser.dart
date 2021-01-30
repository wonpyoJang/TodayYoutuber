import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:TodayYoutuber/main.dart';

class MyInAppBrowser extends InAppBrowser {
  @override
  Future onBrowserCreated() async {
    logger.d("\n\nBrowser Created!\n\n");
  }

  @override
  Future onLoadStart(String url) async {
    logger.d("\n\nStarted $url\n\n");
  }

  @override
  Future onLoadStop(String url) async {
    logger.d("\n\nStopped $url\n\n");
  }

  @override
  void onLoadError(String url, int code, String message) {
    logger.d("Can't load $url.. Error: $message");
  }

  @override
  void onProgressChanged(int progress) {
    logger.d("Progress: $progress");
  }

  @override
  void onExit() {
    logger.d("\n\nBrowser closed!\n\n");
  }

  @override
  Future<ShouldOverrideUrlLoadingAction> shouldOverrideUrlLoading(
      ShouldOverrideUrlLoadingRequest shouldOverrideUrlLoadingRequest) async {
    logger.d("\n\nOverride ${shouldOverrideUrlLoadingRequest.url}\n\n");
    return ShouldOverrideUrlLoadingAction.ALLOW;
  }

  @override
  void onLoadResource(LoadedResource response) {
    logger.d("Started at: " +
        response.startTime.toString() +
        "ms ---> duration: " +
        response.duration.toString() +
        "ms " +
        response.url);
  }

  @override
  void onConsoleMessage(ConsoleMessage consoleMessage) {
    logger.d("""
    console output:
      message: ${consoleMessage.message}
      messageLevel: ${consoleMessage.messageLevel.toValue()}
   """);
  }
}

class WebviewScreen extends StatefulWidget {
  final String url;
  final MyInAppBrowser browser = new MyInAppBrowser();
  WebviewScreen({
    Key key,
    this.url,
  }) : super(key: key);

  @override
  _WebviewScreenState createState() => _WebviewScreenState();
}

class _WebviewScreenState extends State<WebviewScreen> {
  @override
  void initState() {
    logger.d("[build] initState");
    super.initState();
  }

  @override
  void dispose() {
    logger.d("[build] dispose");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    logger.d("[build] WebviewScreen");
    return Scaffold(
        appBar: AppBar(
            title: Text(
          "InAppBrowser",
        )),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              RaisedButton(
                  onPressed: () async {}, child: Text("Open In-App Browser")),
              Container(height: 40),
              RaisedButton(
                  onPressed: () async {
                    await InAppBrowser.openWithSystemBrowser(
                        url: "https://flutter.dev/");
                  },
                  child: Text("Open System Browser")),
            ])));
  }
}
