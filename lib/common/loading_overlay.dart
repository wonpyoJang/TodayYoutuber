import 'package:TodayYoutuber/main.dart';
import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({Key key, this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        StreamBuilder(
            stream: isLoading.stream,
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasData && snapshot.data == true) {
                return Container(
                    color: Colors.black.withOpacity(0.3),
                    child: Center(child: CircularProgressIndicator()));
              } else {
                return Container();
              }
            })
      ],
    );
  }
}
