import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_videodownload/Screen/files.dart';

import 'bottomappbar.dart';

List<Files> files = [];
VideoPlayerController? choose;

class ListScreen extends StatefulWidget {
  ListScreen({Key? key}) : super(key: key);

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Videos",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      bottomNavigationBar: CustomBottomAppBar(),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: GridView.builder(
          itemCount: files.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      10,
                    ),
                  ),
                ),
                child: InkWell(
                  child: files[index].videoPlayerController!.value.isInitialized
                      ? AspectRatio(
                          aspectRatio: files[index]
                              .videoPlayerController!
                              .value
                              .aspectRatio,
                          child:
                              VideoPlayer(files[index].videoPlayerController!),
                        )
                      : const Text("Loading..."),
                  onTap: () {
                    choose = files[index].videoPlayerController;
                    Navigator.of(context).pushNamed("/player");
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
