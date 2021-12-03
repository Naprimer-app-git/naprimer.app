import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:naprimer_app_v2/app/pages/app_controller.dart';
import 'package:naprimer_app_v2/app/pages/profile/general/general_profile_controller.dart';
import 'package:naprimer_app_v2/app/routing/pages.dart';
import 'package:naprimer_app_v2/data/video/video_item.dart';
import 'package:naprimer_app_v2/services/logger/logger_service.dart';
import 'package:naprimer_app_v2/services/video/video_controller.dart';

class ForYouController extends GetxController {
  late VideoController _videoController;
  late Map<String, VideoItem> _videosList;

  late AppController _appController;
  late bool _isLoading;
  final bool isPreviewPage;
  late ScrollController sc;

  ForYouController({this.isPreviewPage = false});

  bool get isLoading => _isLoading;

  VideoController get videoController => _videoController;

  Map<String, VideoItem> get videosList => _videosList;

  bool get isUserAuth => _appController.user != null;

  void onProfilePressed(String authorId) {
    if (_appController.user == null) {
      Get.toNamed(Routes.GENERAL_PROFILE,
          id: ForYouPages.navigatorKeyId,
          arguments: GeneralProfileArguments(authorId));
    } else {
      if (_appController.user!.id != authorId) {
        Get.toNamed(Routes.GENERAL_PROFILE,
            id: ForYouPages.navigatorKeyId,
            arguments: GeneralProfileArguments(authorId));
      }
    }
  }

  @override
  void onInit() {
    _appController = Get.find<AppController>();
    _videoController = _appController.videoController;
    _videosList = {};
    _isLoading = false;

    super.onInit();
  }

  @override
  void onReady() async{
    await _initialFetch();

    super.onReady();
  }

  Future<void> _initialFetch() async {
    _startLoading();
    try {
      if(_appController.user != null){
        await _videoController.fetchUserLikedVideos(userId: _appController.user!.id);
      }
      List<VideoItem> list =
          await _videoController.fetchVideos(nextIndex: _videosList.length);
      list.forEach((element) {
        _videosList[element.id] = element;
      });
    } catch (exception, stackTrace) {
      LoggerService.debugLog(
        exception: exception,
        stackTrace: stackTrace,
      );
    }
    _stopLoading();
  }

  Future<void> onRefresh() async {
    _startLoading();
    try {
      List<VideoItem> list =
          await _videoController.fetchVideos(nextIndex: _videosList.length);
      _videosList.clear();
      list.forEach((element) {
        _videosList[element.id] = element;
      });
    } catch (exception, stackTrace) {
      LoggerService.debugLog(
        exception: exception,
        stackTrace: stackTrace,
      );
    }

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
}
