import 'package:get/get.dart';
import 'package:naprimer_app_v2/app/pages/video_details/video_details_page_controller.dart';
import 'package:naprimer_app_v2/data/video/video_item.dart';

class VideoDetailsPageBindings extends Bindings {
  final VideoItem videoItem;

  VideoDetailsPageBindings({required this.videoItem});

  @override
  void dependencies() {
    Get.put<VideoDetailsPageController>(
        VideoDetailsPageController(videoItem: videoItem));
  }
}
