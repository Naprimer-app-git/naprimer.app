import 'package:get/get.dart';
import 'package:naprimer_app_v2/app/pages/app_controller.dart';
import 'package:naprimer_app_v2/app/pages/profile/profile_tab_controller.dart';
import 'package:naprimer_app_v2/app/pages/profile/profile_tab_type.dart';
import 'package:naprimer_app_v2/data/video/fetch_videos_response.dart';
import 'package:naprimer_app_v2/data/video/video_item.dart';
import 'package:naprimer_app_v2/services/logger/logger_service.dart';
import 'package:naprimer_app_v2/services/video/video_controller.dart';

class PersonalProfileTabController extends GetxController
    implements ProfileTabController {
  final ProfileTabType tabType;
  late VideoController _videoController;
  late List<VideoItem> _videosList;

  PersonalProfileTabController(this.tabType);

  List<VideoItem> get videosList => _videosList;

  late bool _isLoading;

  bool get isLoading => _isLoading;

  @override
  void onInit() {
    _videoController = Get.find<VideoController>();
    _videosList = [];
    _isLoading = false;
    super.onInit();
  }

  @override
  void onReady() async {
    await initialFetch();
    super.onReady();
  }

  Future<void> initialFetch() async {
    _startLoading();
    switch (tabType) {
      case ProfileTabType.Videos:
        await fetchVideos();
        break;
      case ProfileTabType.Unpublished:
        _videosList = [];
        break;
      case ProfileTabType.Likes:
        _videosList = _videoController.likedVideos;
        break;
    }
    _stopLoading();
    update();
  }

  Future<void> fetchVideos() async {
    try {
      List<VideoItem> videos = await _videoController.fetchVideos(
          nextIndex: _videosList.length, itemCnt: 2);

      _videosList.addAll(videos);
    } catch (exception, stackTrace) {
      LoggerService.debugLog(exception: exception, stackTrace: stackTrace);
    }
  }

  Future<void> onRefresh() async {
    _startLoading();
    //todo add try catch - needs to discuss what to show
    List<VideoItem> videos = [];
    try {
      switch (tabType) {
        case ProfileTabType.Videos:
          FetchVideosResponse response = await _videoController.fetchUserVideos(
              userId: Get.find<AppController>().user!.id);
          videos = response.videos;
          break;
        case ProfileTabType.Unpublished:
          //todo needs to be finished when unpublished will be ready;
          //for debug purposes
          videos = [];
          break;
        case ProfileTabType.Likes:
          videos = await _videoController.fetchUserLikedVideos(
              userId: Get.find<AppController>().user!.id);
          break;
      }
      _videosList.clear();
      _videosList.addAll(videos);
    } catch (e) {}
    _stopLoading();
  }

  void _startLoading({List<Object>? ids}) {
    _isLoading = true;
    update(ids);
  }

  void _stopLoading({List<Object>? ids}) {
    _isLoading = false;
    update(ids);
  }

  @override
  void onProfilePressed(String authorId) {
    // TODO: what should be here?
  }
}