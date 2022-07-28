import 'package:the_endodontist_app/widgets/video_player.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class AssetPlayer extends StatefulWidget {
  static const routeName = '/asset_player';
  const AssetPlayer({Key? key}) : super(key: key);

  @override
  _AssetPlayerState createState() => _AssetPlayerState();
}

class _AssetPlayerState extends State<AssetPlayer> {
  late VideoPlayerController vcontroller;
  final asset = 'assets/ Calendar.mp4';
  @override
  void initState() {
    super.initState();
    vcontroller = VideoPlayerController.asset(asset)
      ..addListener(() => setState(() {}))
      ..setLooping(true)
      ..initialize().then((_) => vcontroller.play());
  }

  @override
  void dispose() {
    vcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMuted = vcontroller.value.volume == 0;
    return Column(
      children: [
        VideoPlayerWidget(controller: vcontroller),
        const SizedBox(height: 39),
        if (vcontroller.value.isInitialized)
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.amber,
            child: IconButton(
              onPressed: () => vcontroller.setVolume(isMuted ? 1 : 0),
              icon: Icon(
                isMuted ? Icons.volume_mute : Icons.volume_up,
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }
}
