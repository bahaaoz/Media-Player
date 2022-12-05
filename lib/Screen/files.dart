import 'dart:io';

import 'package:video_player/video_player.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class Files {
  File? file;
  VideoPlayerController? videoPlayerController;

  Files(File file) {
    this.file = file;
    videoPlayerController = VideoPlayerController.file(
      file,
      videoPlayerOptions: VideoPlayerOptions(
        allowBackgroundPlayback: true,
      ),
    );
  }
}
