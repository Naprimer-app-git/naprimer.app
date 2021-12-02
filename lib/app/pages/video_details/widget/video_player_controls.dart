import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:naprimer_app_v2/app/pages/video_details/video_details_page.dart';
import 'package:naprimer_app_v2/app/pages/video_details/widget/slider_thumb_image.dart';
import 'package:naprimer_app_v2/app/pages/video_details/widget/video_control_buttons.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerControls extends StatefulWidget {
  final VideoPlayerState videoPlayerState;
  final Function onPausePressed;
  final Function onPlayPressed;
  final Function onFastForwardPressed;
  final Function onFastBackwardPressed;
  final Function onSeekPressed;
  final VideoPlayerController videoPlayerController;

  const VideoPlayerControls(
      {Key? key,
      required this.videoPlayerState,
      required this.onPausePressed,
      required this.onPlayPressed,
      required this.onFastForwardPressed,
      required this.onFastBackwardPressed,
      required this.onSeekPressed,
      required this.videoPlayerController})
      : super(key: key);

  @override
  State<VideoPlayerControls> createState() => _VideoPlayerControlsState();
}

class _VideoPlayerControlsState extends State<VideoPlayerControls> {
  late StreamController<double> playerPositionController;

  Stream<double> get playerPosition => playerPositionController.stream;

  @override
  void initState() {
    super.initState();

    playerPositionController = StreamController();

    widget.videoPlayerController.addListener(() {
      //todo needs to be checked and probably removed
      if (playerPositionController.isClosed) {
        playerPositionController = StreamController();
        widget.videoPlayerController.addListener(() {
          playerPositionController.sink.add(widget
              .videoPlayerController.value.position.inMilliseconds
              .toDouble());
        });
      } else {
        playerPositionController.sink.add(widget
            .videoPlayerController.value.position.inMilliseconds
            .toDouble());
      }
    });
  }

  @override
  void dispose() {
    playerPositionController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildBody(),
        const SizedBox(height: 24),
        _buildSlider(
            playerPosition: playerPosition,
            onSeekPressed: widget.onSeekPressed,
            videoPlayerController: widget.videoPlayerController),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Text(_formatDuration(widget.videoPlayerController.value.position)),
              Spacer(),
              Text(_formatDuration(widget.videoPlayerController.value.duration)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    switch (widget.videoPlayerState) {
      case VideoPlayerState.NOT_INIT:
        return _buildNotInitStateControls();
      case VideoPlayerState.PLAYING:
        return _buildPlayStateControls();
      case VideoPlayerState.PAUSED:
        return _buildPauseStateControls();
    }
  }

  Widget _buildNotInitStateControls() {
    return Container();
  }

  Widget _buildPlayStateControls() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            VideoControlButtons.fastBackward(
                onPressed: widget.onFastBackwardPressed),
            VideoControlButtons.pauseButton(onPressed: widget.onPausePressed),
            VideoControlButtons.fastForward(
                onPressed: widget.onFastForwardPressed),
          ],
        ),
      ],
    );
  }

  Widget _buildPauseStateControls() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            VideoControlButtons.fastBackward(
                onPressed: widget.onFastBackwardPressed),
            VideoControlButtons.playButton(onPressed: widget.onPlayPressed),
            VideoControlButtons.fastForward(
                onPressed: widget.onFastForwardPressed),
          ],
        )
      ],
    );
  }

  Widget _buildSlider(
      {required Stream playerPosition,
      required Function onSeekPressed,
      required VideoPlayerController videoPlayerController}) {
    return StreamBuilder(
      initialData: 0,
      stream: playerPosition,
      builder: (context, snap) {
        double progress = 0.0;
        if (snap.hasData) {
          progress =
              videoPlayerController.value.position.inMilliseconds.toDouble();
        }
        return SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.white.withOpacity(0.34),
            inactiveTrackColor: Colors.white.withOpacity(0.34),
            trackShape: RectangularSliderTrackShape(),
            trackHeight: 4.0,
            thumbColor: Colors.white,
            thumbShape: SliderThumbImage(
              22,
              6,
              thumbColor: Colors.white,
              dotColor: Colors.white,
            ),
            overlayColor: Colors.white.withOpacity(0.34),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 16.0),
          ),
          child: Slider(
            value: progress >= 0 &&
                    progress <=
                        videoPlayerController.value.duration.inMilliseconds
                            .toDouble()
                ? progress
                : 0,
            min: 0,
            max: videoPlayerController.value.duration.inMilliseconds.toDouble(),
            onChanged: (double value) => onSeekPressed(value),
          ),
        );
      },
    );
  }


  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}
