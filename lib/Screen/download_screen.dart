import 'dart:io';

import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_videodownload/Screen/bottomappbar.dart';
import 'package:youtube_videodownload/Screen/files.dart';
import 'package:youtube_videodownload/Screen/listScreen.dart';

class DownloadScreen extends StatefulWidget {
  DownloadScreen({Key? key}) : super(key: key);

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  TextEditingController textController = TextEditingController();
  double progressVal = 0;

  int status = 0;
  String videoId = "";
  String videoTitel = "";
  String videoAuther = "";
  bool prograsshiden = true;
  //String imgURL = "https://img.youtube.com/vi/$videoId/0.jpg";
  String error = "";
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: loading,
      child: Scaffold(
        bottomNavigationBar: CustomBottomAppBar(),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      status = 2;
                    });
                  },
                  controller: textController,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        textController.text = "";
                        setState(() {
                          status = 2;
                        });
                      },
                      icon: const Icon(
                        Icons.clear,
                      ),
                    ),
                    label: const Text(
                      "Search",
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              status == 0 || status == 2
                  ? Expanded(
                      child: Column(
                        children: [
                          Container(
                            height: 40,
                            width: 100,
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  40,
                                ),
                              ),
                            ),
                            child: MaterialButton(
                              child: const Text(
                                "Search",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () {
                                if (textController.text.isEmpty) {
                                  return;
                                }
                                setState(() {
                                  loading = true;
                                });
                                getVideoInfo(textController.text);
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            error,
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      child: Column(
                        children: [
                          Container(
                            child: Image.network(
                                "https://img.youtube.com/vi/$videoId/0.jpg"),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            videoAuther,
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            videoTitel,
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          !prograsshiden
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: LinearProgressIndicator(
                                    value: progressVal,
                                  ),
                                )
                              : Container(
                                  height: 40,
                                  width: 170,
                                  decoration: const BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                        40,
                                      ),
                                    ),
                                  ),
                                  child: MaterialButton(
                                    child: const Text(
                                      "Start Download",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    onPressed: () {
                                      downloadVideo(textController.text);
                                    },
                                  ),
                                ),
                        ],
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }

  void getVideoInfo(String url) async {
    try {
      var youtube = YoutubeExplode();
      var video = await youtube.videos.get(url);
      setState(() {
        status = 1;
        videoAuther = video.author;
        videoTitel = video.title;
        videoId = video.id.value;
        loading = false;
        error = "";
      });
    } catch (e) {
      setState(() {
        error = "wrong url";
        loading = false;
        status = 2;
      });
    }
  }

  void downloadVideo(String url) async {
    try {
      if (await requestPermission(Permission.storage) &&
          await requestPermission(Permission.manageExternalStorage)) {
        var youtube = YoutubeExplode();
        var video = await youtube.videos.get(url);
        var manifest = await youtube.videos.streamsClient.getManifest(url);
        var streams = manifest.muxed.withHighestBitrate();
        var audio = streams;
        var audioStream = youtube.videos.streamsClient.get(audio);

        Directory? dir = await getExternalStorageDirectory();
        String path = dir!.path;
        List<String> list = path.split("/");
        path = "";
        for (int i = 1; i < list.length; i++) {
          if (list[i] != "Android") {
            path += "/${list[i]}";
          } else {
            break;
          }
        }
        path += "/youtubevideob";
        print(path);
        var file = File("$path/${video.id}.mp4");
        print(path);
        await Directory(path).create();

        if (file.existsSync()) {
          file.deleteSync();
        }

        var output = file.openWrite(mode: FileMode.writeOnlyAppend);
        var size = audio.size.totalBytes;
        var count = 0;

        await for (final data in audioStream) {
          count += data.length;
          double val = (count / size);
          setState(() {
            prograsshiden = false;
            progressVal = val;
          });
          output.add(data);
        }
        files.add(Files(file));
        await files[files.length - 1].videoPlayerController!.initialize();
      }

      setState(() {
        prograsshiden = true;
        progressVal = 0;
        status = 2;
        error = "Done";
      });
    } catch (e) {
      setState(() {
        status = 2;
        error = "Wrong";
      });
    }
  }

  Future<bool> requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var check = await permission.request();
      if (check.isGranted) {
        return true;
      } else {
        return false;
      }
    }
  }
}
