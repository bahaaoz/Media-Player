import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_videodownload/Screen/listScreen.dart';

class PlayerScreen extends StatefulWidget {
  PlayerScreen({Key? key}) : super(key: key);

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  bool playV = false;
  bool replay = false;
  @override
  void initState() {
    choose!.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            AspectRatio(
                aspectRatio: choose!.value.aspectRatio,
                child: VideoPlayer(choose!)),
            const SizedBox(
              height: 10,
            ),
            VideoProgressIndicator(
              choose!,
              allowScrubbing: true,
              colors: const VideoProgressColors(
                backgroundColor: Color.fromARGB(255, 176, 240, 246),
                playedColor: Color.fromARGB(255, 8, 0, 255),
                bufferedColor: Color.fromARGB(255, 176, 240, 246),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 236, 235, 235),
                borderRadius: BorderRadius.circular(
                  30,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 40,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: IconButton(
                      onPressed: () {
                        if (!playV) {
                          choose!.pause();
                        } else {
                          choose!.play();
                        }

                        setState(() {
                          playV = !playV;
                        });
                      },
                      icon: Icon(
                        playV ? Icons.play_arrow : Icons.pause,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: IconButton(
                      onPressed: () {
                        if (replay) {
                          choose!.setLooping(false);
                        } else {
                          choose!.setLooping(true);
                        }

                        setState(() {
                          replay = !replay;
                        });
                      },
                      icon: Icon(
                        Icons.replay,
                        color: replay ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
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
                        child: SizedBox(
                          width: 80,
                          height: 80,
                          child: files[index]
                                  .videoPlayerController!
                                  .value
                                  .isInitialized
                              ? AspectRatio(
                                  aspectRatio: files[index]
                                      .videoPlayerController!
                                      .value
                                      .aspectRatio,
                                  child: VideoPlayer(
                                      files[index].videoPlayerController!),
                                )
                              : const Text("Loading..."),
                        ),
                        onTap: () {
                          setState(() {
                            choose = files[index].videoPlayerController;
                            choose!.seekTo(Duration(seconds: 0));
                            choose!.setPlaybackSpeed(10);
                            replay = false;
                            choose!.play();
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
