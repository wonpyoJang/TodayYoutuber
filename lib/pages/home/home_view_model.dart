import 'package:TodayYoutuber/models/channel.dart';
import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  List<Channel> _channels = [
    Channel(
      name: "코드팩토리",
      image:
          "https://yt3.ggpht.com/ytc/AAUvwnhZKDZBlIH-AAMyl6Jxit6MdKcqx7a68VDT5mwR=s88-c-k-c0x00ffffff-no-rj",
      link: "https://www.youtube.com/channel/UCxZ2AlaT0hOmxzZVbF_j_Sw/featured",
      subscribers: 1280,
    )
  ];

  List<Channel> get channels => _channels;
  int get lengthOfChannels => _channels.length;

  void setLike(int index) => _channels[index].setLike();
  void unsetLike(int index) => _channels[index].unsetLike();

  void toggleLike(int index) {
    if (_channels[index].isLike) {
      this.unsetLike(index);
    } else {
      this.setLike(index);
    }
    notifyListeners();
  }

  Future<void> fetchMovies(String keyword) async {
    notifyListeners();
  }
}
