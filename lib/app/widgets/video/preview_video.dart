import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:naprimer_app_v2/app/config/camera_config.dart';
import 'package:video_player/video_player.dart';

abstract class AbstractPreviewConfig {
  AbstractPreviewConfig(
      {required this.videoUrl,
      this.previewImagePath = '',
      this.isCropCenter = false,
      this.isSoundEnabled = false});

  final String videoUrl;
  final String previewImagePath;
  final bool isCropCenter;
  final bool isSoundEnabled;
}

class PreviewConfig implements AbstractPreviewConfig {
  PreviewConfig(
      {required this.videoUrl,
      this.previewImagePath = '',
      this.isCropCenter = false,
      this.isSoundEnabled = false});

  @override
  final String videoUrl;
  @override
  final String previewImagePath;
  @override
  final bool isCropCenter;
  @override
  final bool isSoundEnabled;
}

class PreviewVideo extends StatefulWidget {
  final AbstractPreviewConfig config;

  PreviewVideo({required this.config});

  @override
  State<StatefulWidget> createState() => PreviewVideoState();
}

class PreviewVideoState extends State<PreviewVideo> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    _controller = VideoPlayerController.network(widget.config.videoUrl);
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _controller.initialize().then((_) {
        setState(() {
          _controller.setLooping(true);
          _controller.setVolume(widget.config.isSoundEnabled ? 1.0 : 0.0);
          _controller.play();
        });
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) showPlaceholder();
    if (widget.config.isCropCenter) {
      return _buildCropCenterBody();
    } else {
      return _buildDefaultBody(context);
    }
  }

  Widget showPlaceholder() {
    if (widget.config.previewImagePath.isEmpty) {
      return Container();
    } else {
      return Container(
        child: Image.file(File(widget.config.previewImagePath)),
      );
    }
  }

  Widget _buildDefaultBody(BuildContext context) {
    final deviceRatio = context.width / context.height;
    return Center(
      child: ClipRRect(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        borderRadius: BorderRadius.circular(12.0),
        child: Transform.scale(
          scale: !CAMERA_RECTANGLE_MODE
              ? 1
              : (_controller.value.aspectRatio) / deviceRatio,
          child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller)),
        ),
      ),
    );
  }

  Widget _buildCropCenterBody() {
    final Size size = _controller.value.size;

    return ClipRRect(
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: size.width,
            height: size.height,
            child: VideoPlayer(_controller),
          ),
        ),
      ),
    );
  }
}
