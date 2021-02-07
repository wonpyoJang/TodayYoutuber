import 'package:TodayYoutuber/pages/home/home.dart';
import 'package:TodayYoutuber/pages/received_channels/received_channels.dart';
import 'package:flutter/material.dart';

class RouteManager {
  static RouteFactory namesToScreen = (settings) {
    var args = settings.arguments;

    switch (settings.name) {
      case RouteLists.home:
        return MaterialPageRoute(
          builder: (context) {
            return HomeScreen();
          },
        );
        break;
      case RouteLists.receivedChannels:
        return MaterialPageRoute(
          builder: (context) {
            return ReceivedChannelsScreen(
              args: args,
            );
          },
        );
        break;
      default:
        return null;
        break;
    }
  };
}

class RouteLists {
  static const String home = '/home';
  static const String receivedChannels = '/received_channels';
}
