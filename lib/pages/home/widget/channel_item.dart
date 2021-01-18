import 'package:TodayYoutuber/pages/home/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChannelItem extends StatelessWidget {
  const ChannelItem({
    Key key,
    @required this.channelIndex,
  }) : super(key: key);

  final int channelIndex;

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<HomeViewModel>(context);
    final channel = vm.channels[channelIndex];
    return InkWell(
      onTap: () async {
        print("HomeScreen, onTap on List");
        channel.openUrlWithInappBrowser();
      },
      child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 5.0,
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(channel.image),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(channel.name),
                  Text("구독자 : ${channel.subscribers}",
                      style: TextStyle(fontSize: 10))
                ],
              ),
              Expanded(child: SizedBox()),
              GestureDetector(
                  onTap: () {
                    print("Home, build, like button, tappled");
                    vm.toggleLike(channelIndex);
                  },
                  child: Container(
                      child: Icon(channel.isLike
                          ? Icons.favorite_rounded
                          : Icons.favorite_border))),
              SizedBox(width: 15)
            ],
          )),
    );
  }
}
