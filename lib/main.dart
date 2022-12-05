import 'package:flutter/material.dart';
import 'package:youtube_videodownload/Screen/download_screen.dart';
import 'package:youtube_videodownload/Screen/listScreen.dart';
import 'package:youtube_videodownload/Screen/playerScreen.dart';
import 'package:youtube_videodownload/Screen/splash.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "/search": (context) => DownloadScreen(),
        "/list": (context) => ListScreen(),
        "/player": (context) => PlayerScreen(),
      },
      debugShowCheckedModeBanner: false,
      home: const Splash(),
    );
  }
}
