import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class ControlAudioButton extends StatelessWidget {
  final AudioPlayer player;

  const ControlAudioButton(this.player, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(icon: const Icon(Icons.volume_up), onPressed: () {}),
        StreamBuilder(
            stream: player.playerStateStream,
            builder: (context, snapshot) {
              if (!player.playing) {
                return IconButton(
                    icon: const Icon(
                      Icons.play_arrow,
                      color: Colors.amber,
                    ),
                    iconSize: 64.0,
                    onPressed: player.play);
              }

              return Container();
            })
      ],
    );
  }
}
