import 'package:get/get.dart';
import 'package:naprimer_app_v2/app/pages/video_details/video_details_page.dart';
import 'package:naprimer_app_v2/app/utils/date_time_ext.dart';
import 'package:naprimer_app_v2/app/utils/int_ext.dart';
import 'package:naprimer_app_v2/data/video/video_item.dart';
import 'package:naprimer_app_v2/services/user_controller.dart';
import 'package:naprimer_app_v2/services/video/video_controller.dart';
import 'package:video_player/video_player.dart';

class VideoDetailsPageController extends GetxController {
  final VideoItem videoItem;

  VideoDetailsPageController({required this.videoItem});

  late VideoPlayerController videoPlayerController;
  late VideoController _videoController;
  late bool _isControlsVisible;

  bool isVideoFullViewed = false;

  bool get isControlsVisible => _isControlsVisible;

  //todo mb likes and views should be obx
  bool get isVideoLiked => _videoController.isVideoLiked(videoItem.id);

  String? get authorAvatar => videoItem.authorAvatar;

  String get likeCnt => videoItem.interactions.likesCount.roundCount;

  String get viewsCnt => videoItem.interactions.viewsCount.roundCount;

  String get title => videoItem.title;

  String get releasedAt =>
      videoItem.modifiedAt?.getTimeFromPublish ??
      DateTime.now().getTimeFromPublish;

  String get author => videoItem.authorName;

  static const controlsId = 'controlsId';
  static const likesId = 'likesId';
  Rx<VideoPlayerState> state = VideoPlayerState.NOT_INIT.obs;

  double get aspectRatio => videoPlayerController.value.aspectRatio;

  bool get isPersonal =>
      videoItem.authorId == Get.find<UserController>().user.value?.id;

  @override
  void onInit() {
    state.value = VideoPlayerState.NOT_INIT;
    videoPlayerController = VideoPlayerController.network(videoItem.stream);
    videoPlayerController.addListener(onVideoDataChanged);
    _videoController = Get.find<VideoController>();
    _isControlsVisible = false;
    super.onInit();
  }

  @override
  void onReady() {
    videoPlayerController.initialize().then((_) {
      state.value = VideoPlayerState.PLAYING;
      videoPlayerController.setVolume(1.0);
      videoPlayerController.play();
      videoPlayerController.setLooping(true);
    });

    super.onReady();
  }

  @override
  void onClose() {
    videoPlayerController.removeListener(onVideoDataChanged);
    videoPlayerController.dispose();
    isVideoFullViewed = false;
    super.onClose();
  }

  void toggleControlsVisibility() {
    _isControlsVisible = !_isControlsVisible;
    update([controlsId]);
  }

  void onFastBackwardPressed() {
    videoPlayerController
        .seekTo(videoPlayerController.value.position - Duration(seconds: 10));
  }

  void onFastForwardPressed() {
    videoPlayerController
        .seekTo(videoPlayerController.value.position + Duration(seconds: 20));
  }

  void onSeekPressed(double value) {
    videoPlayerController.seekTo(Duration(milliseconds: value.toInt()));
  }

  void onBackPressed() {
    Get.back();
  }

  void onPausePressed() {
    state.value = VideoPlayerState.PAUSED;
    videoPlayerController.pause();
  }

  void onPlayPressed() {
    state.value = VideoPlayerState.PLAYING;
    videoPlayerController.play();
  }

  void onEditPressed() {
    //todo will be finished on next PR
    // Get.toNamed(Routes.PUBLISH);
  }

  void onLikePressed() async {
    if (!isVideoLiked) {
      videoItem.interactions.likesCount++;
    } else {
      videoItem.interactions.likesCount--;
    }
    await _videoController.toggleLikeVideo(
        video: videoItem, isLiked: !isVideoLiked);
    update([VideoDetailsPageController.likesId]);
  }

  void onVideoDataChanged() {
    if (!isVideoFullViewed &&
        videoPlayerController.value.duration.inSeconds -
                videoPlayerController.value.position.inSeconds <
            0.5) {
      isVideoFullViewed = true;
      Get.find<VideoController>().incrementVideoViewCounter(videoItem.id);
    }
  }
}
