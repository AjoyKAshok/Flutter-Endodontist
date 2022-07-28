import 'package:the_endodontist_app/widgets/basic_overlay.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatelessWidget {
  static const routeName = '/video_widget';
  final VideoPlayerController controller;
  const VideoPlayerWidget({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) => controller.value.isInitialized
      ? Container(
          alignment: Alignment.topCenter,
          child: buildVideo(),
        )
      : Container(
          height: 200,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
  Widget buildVideo() => Stack(
    children: [
      buildVideoPlayer(),
      Positioned.fill(child: BasicOverlayWidget(controller: controller),)
    ],
  );

  Widget buildVideoPlayer() => AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: VideoPlayer(controller));
}
