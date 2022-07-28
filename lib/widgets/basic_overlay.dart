import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class BasicOverlayWidget extends StatelessWidget {
  final VideoPlayerController controller;
  const BasicOverlayWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          Positioned(
            child: buildIndicator(),
            bottom: 0,
            left: 0,
            right: 0,
          ),
        ],
      );

  buildIndicator() => VideoProgressIndicator(
        controller,
        allowScrubbing: true,
      );
}
