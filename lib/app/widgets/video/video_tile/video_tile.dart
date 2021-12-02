import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naprimer_app_v2/app/pages/app_controller.dart';
import 'package:naprimer_app_v2/app/routing/pages.dart';
import 'package:naprimer_app_v2/app/styling/app_text_theme.dart';
import 'package:naprimer_app_v2/app/utils/date_time_ext.dart';
import 'package:naprimer_app_v2/app/utils/int_ext.dart';
import 'package:naprimer_app_v2/app/utils/string_ext.dart';
import 'package:naprimer_app_v2/app/widgets/avatar/circle_avatar.dart';
import 'package:naprimer_app_v2/app/widgets/buttons/button_wrapper.dart';
import 'package:naprimer_app_v2/app/widgets/buttons/like_button.dart';
import 'package:naprimer_app_v2/app/widgets/video/video_tile_preview.dart';
import 'package:naprimer_app_v2/data/video/video_item.dart';
import 'package:naprimer_app_v2/services/video/video_controller.dart';

enum VideoState { UPLOADING, PROCESSING, READY }

extension VideoStateData on VideoState {
  String get label {
    switch (this) {
      case VideoState.UPLOADING:
        return 'Uploading';
      case VideoState.PROCESSING:
        return 'Processing';
      case VideoState.READY:
        return 'Ready';
    }
  }
}

class VideoTile extends StatefulWidget {
  final bool isInView;
  final bool isUserAuth;
  final VideoItem videoItem;
  final Function onProfilePressed;

  VideoTile({
    this.isInView = false,
    required this.isUserAuth,
    required this.videoItem,
    required this.onProfilePressed,
  });

  @override
  State<VideoTile> createState() => _VideoTileState();
}

class _VideoTileState extends State<VideoTile> {
  String get authorName => widget.videoItem.authorName.truncate(40);

  String get videoTitle => widget.videoItem.title;

  String? get imagePreview => widget.videoItem.imagePreview;

  String get videoPreview => widget.videoItem.stream;

  String get likes => widget.videoItem.interactions.likesCount.roundCount;

  bool get isLiked =>
      Get.find<VideoController>().isVideoLiked(widget.videoItem.id);

  String get videoItemId => widget.videoItem.id;

  bool isLikeEnabled = true;

  @override
  Widget build(BuildContext context) {
    return ButtonWrapper(
      onTap: onGoToVideoPressed,
      onDoubleTap: onLikePressed,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          buildAvatarTitle(context),
          const SizedBox(height: 12),
          buildBody(context),
          const SizedBox(height: 12),
          buildViewsLabel(widget.videoItem),
        ],
      ),
    );
  }

  Widget buildAvatarTitle(BuildContext context) {
    return ButtonWrapper(
      onTap: () => widget.onProfilePressed(widget.videoItem.authorId),
      child: Row(
        children: <Widget>[
          AppAvatarFactory.asset(),
          const SizedBox(
            width: 8,
          ),
          Flexible(
            child: Text(authorName,
                maxLines: 2, style: AppTextTheme.profileNameSmallStyle),
          )
        ],
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    double width = (MediaQuery.of(context).size.width / 2);
    const height = 250.0;
    return Container(
      width: width,
      height: height,
      child: _buildBodyForVideoState(videoState()),
    );
  }

  Widget _buildBodyForVideoState(VideoState videoState) {
    switch (videoState) {
      case VideoState.UPLOADING:
      case VideoState.PROCESSING:
        return _buildLoadingWidget(videoState);
      case VideoState.READY:
        return Stack(
          children: [
            TileVideoPreview(
              videoItemId: videoItemId,
              imagePreview: imagePreview!,
              videoPreview: videoPreview,
              isInView: widget.isInView,
            ),
            Align(
              alignment: AlignmentDirectional.topEnd,
              child: LikeButton(
                  likesCountString: likes,
                  isLiked: isLiked,
                  onTap: onLikePressed),
            ),
          ],
        );
    }
  }

  Widget _buildLoadingWidget(VideoState videoState) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircularProgressIndicator(
          backgroundColor: Colors.white.withOpacity(0.3),
          strokeWidth: 1.5,
        ),
        const SizedBox(height: 8),
        Text(
          videoState.label,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  Widget buildViewsLabel(VideoItem item) {
    String timeFromRelease = item.modifiedAt?.getTimeFromPublish ?? '';
    String viewsCount = item.interactions.viewsCount.roundCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 16,
          child: Text(
            '$timeFromRelease  ∙  $viewsCount views',
            style: TextStyle(fontSize: 12, height: 1.4, color: Colors.white70),
          ),
        ),
        Text(
          videoTitle,
          style:
              TextStyle(fontSize: 14, height: 1.4, fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
      ],
    );
  }

  Future<void>? onLikePressed() async {
    if (!isLikeEnabled) return null;

    if (Get.find<AppController>().user != null) {
      setState(() {
        isLikeEnabled = false;
      });
      await toggleLike();

      setState(() {
        isLikeEnabled = true;
      });
    } else {
      Get.toNamed(Routes.AUTH);
    }
  }

  Future<void> toggleLike() async {
    widget.videoItem.interactions.likesCount += !isLiked ? 1 : -1;
    await Get.find<VideoController>()
        .toggleLikeVideo(video: widget.videoItem, isLiked: !isLiked);
  }

  VideoState videoState() {
    return VideoState.READY;
    //todo not ready to be implemented
    // return VideoState.PROCESSING;
    // return VideoState.UPLOADING;
    // // if (videoItem.isDraft) {
    // //   MyUserModel userModel = Modular.get<MyUserModel>();
    // //   return userModel.videoIsUploading(videoItem.id)
    // //       ? _VideoState.processing
    // //       : _VideoState.uploading;
    // // } else {
    // //   return _VideoState.ready;
    // // }
  }

  void onGoToVideoPressed() {
    Get.toNamed(Routes.VIDEO_DETAILS_PAGE, arguments: widget.videoItem);
  }
}
