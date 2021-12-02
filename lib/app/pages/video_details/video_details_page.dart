import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:naprimer_app_v2/app/config/camera_config.dart';
import 'package:naprimer_app_v2/app/pages/video_details/video_details_page_controller.dart';
import 'package:naprimer_app_v2/app/styling/app_text_theme.dart';
import 'package:naprimer_app_v2/app/widgets/avatar/circle_avatar.dart';
import 'package:naprimer_app_v2/app/widgets/buttons/button_wrapper.dart';
import 'package:naprimer_app_v2/app/widgets/buttons/custom_icon_button.dart';
import 'package:video_player/video_player.dart';

import 'widget/video_player_controls.dart';

enum VideoPlayerState { NOT_INIT, PLAYING, PAUSED }

class VideoDetailsPage extends GetView<VideoDetailsPageController> {
  const VideoDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      switch (controller.state.value) {
        case VideoPlayerState.NOT_INIT:
          return Container(
            child: Image.network(
              controller.videoItem.imagePreview!,
              fit: BoxFit.fitWidth,
              filterQuality: FilterQuality.medium,
            ),
          );
        case VideoPlayerState.PLAYING:
        case VideoPlayerState.PAUSED:
          return _buildVideoPlayer(context);
      }
    });
  }

  Widget _buildVideoPlayer(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              controller.toggleControlsVisibility();
            },
            child: Stack(
              children: [
                Transform.scale(
                  scale: calculateScale(context),
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: controller.aspectRatio,
                      child: VideoPlayer(controller.videoPlayerController),
                    ),
                  ),
                ),
                GetBuilder<VideoDetailsPageController>(
                    id: VideoDetailsPageController.controlsId,
                    builder: (_) {
                      return AnimatedOpacity(
                        opacity: controller.isControlsVisible ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 200),
                        child: Material(
                            color: Colors.black.withOpacity(0.56),
                            child: _buildControlLayer()),
                      );
                    }),
              ],
            ),
          ),
          SafeArea(
            child: Align(
              alignment: AlignmentDirectional.topStart,
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0, left: 4),
                child: CustomIconButton(
                    iconData: Icons.close, onTap: controller.onBackPressed),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlLayer() {
    return IgnorePointer(
      ignoring: !controller.isControlsVisible,
      child: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: AlignmentDirectional.topStart,
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0, left: 4),
                child: CustomIconButton(
                    iconData: Icons.close, onTap: controller.onBackPressed),
              ),
            ),
            Align(
                alignment: AlignmentDirectional.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: _buildTopControls(),
                )),
            Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VideoPlayerControls(
                    videoPlayerController: controller.videoPlayerController,
                    videoPlayerState: controller.state.value,
                    onPlayPressed: controller.onPlayPressed,
                    onPausePressed: controller.onPausePressed,
                    onFastForwardPressed: controller.onFastForwardPressed,
                    onFastBackwardPressed: controller.onFastBackwardPressed,
                    onSeekPressed: controller.onSeekPressed,
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${controller.viewsCnt} views',
                          style: AppTextTheme.caption,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          controller.title,
                          style: AppTextTheme.titleTextStyle2,
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopControls() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildProfileControl(),
          const SizedBox(height: 20),
          _buildLikesWidget(),
          Visibility(
            visible: controller.isPersonal,
            child: _buildEditWidget(),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileControl() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(controller.author),
            const SizedBox(height: 6),
            Text(controller.releasedAt),
          ],
        ),
        const SizedBox(width: 12),
        AppAvatarFactory.asset(size: Size(40, 40))
      ],
    );
  }

  Widget _buildLikesWidget() {
    return GetBuilder<VideoDetailsPageController>(
        id: VideoDetailsPageController.likesId,
        builder: (_) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('${controller.likeCnt}'),
              const SizedBox(width: 8),
              _buildCircleIcon(
                  iconData: controller.isVideoLiked
                      ? Icons.favorite_rounded
                      : Icons.favorite_outline_rounded,
                  backgroundColor: Colors.grey,
                  onTap: controller.onLikePressed),
            ],
          );
        });
  }

  Widget _buildEditWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: _buildCircleIcon(
          iconData: Icons.more_vert_rounded,
          backgroundColor: Colors.grey,
          onTap: controller.onEditPressed),
    );
  }

  Widget _buildCircleIcon(
      {required Function onTap,
      required IconData iconData,
      required Color backgroundColor}) {
    return ButtonWrapper(
      onTap: () => onTap(),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.6),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        width: 40,
        height: 40,
        child: Icon(
          iconData,
          size: 24,
        ),
      ),
    );
  }

  double calculateScale(BuildContext context) {
    final deviceRatio = context.width / context.height;
    return CAMERA_RECTANGLE_MODE ? (controller.aspectRatio) / deviceRatio : 1;
  }
}
