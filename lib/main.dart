import 'package:flutter/material.dart';
import 'package:track_me_beacon/homeScreen.dart';
import 'package:track_me_beacon/share_location_screen.dart';
import 'package:track_me_beacon/show_map_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Beacon',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
      routes:{
        ShareLocationScreen.routeName:(_)=>ShareLocationScreen(),
        ShowMapScreen.routeName:(_)=>ShowMapScreen(),
      }
    );
  }
}
