import 'package:TodayYoutuber/pages/home/home.dart';
import 'package:TodayYoutuber/pages/home/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: ChangeNotifierProvider(
            create: (context) => HomeViewModel(), child: HomeScreen()));
  }
}
