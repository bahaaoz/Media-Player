import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:youtube_videodownload/Screen/files.dart';
import 'package:youtube_videodownload/Screen/listScreen.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    readData();
  }

  readData() async {
    await getVideos();
    Navigator.of(context).pushReplacementNamed("/list");
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

//here
  Future<void> getVideos() async {
    files.clear();
    String path = "/storage/emulated/0/youtubevideob";
    var p = await Permission.manageExternalStorage.request();
    if (p.isDenied) {
      return;
    }

    var v = await Directory(path).create();
    List<FileSystemEntity> list =
        v.listSync(followLinks: false, recursive: true);
    int count = 0;
    for (var x in list) {
      files.add(Files(File(x.path)));
      await files[count].videoPlayerController!.initialize();
      count++;
    }
  }
}
