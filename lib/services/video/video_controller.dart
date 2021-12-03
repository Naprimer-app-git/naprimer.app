import 'package:get/get.dart';
import 'package:naprimer_app_v2/data/video/fetch_videos_response.dart';
import 'package:naprimer_app_v2/data/video/search_videos_response.dart';
import 'package:naprimer_app_v2/data/video/video_item.dart';
import 'package:naprimer_app_v2/data/video/video_repository.dart';
import 'package:naprimer_app_v2/services/logger/logger_service.dart';

class VideoController extends GetxController {
  late VideoRepository _videoRepository;
  late Map<String, VideoItem> _likedVideos;

  List<VideoItem> get likedVideos =>
      _likedVideos.entries.map((entry) => entry.value).toList();

  @override
  void onInit() {
    _videoRepository = Get.find<VideoRepository>();
    _likedVideos = {};
    super.onInit();
  }

  Future<List<VideoItem>> fetchUserLikedVideos(
      {required String userId, String next = '', int limit = 10}) async {
    List<VideoItem> list = [];

    try {
      list = await _videoRepository.fetchLikedVideos(
          userId: userId, next: next, limit: limit);
      _likedVideos = Map.fromIterable(list, key: (k) => k.id, value: (v) => v);
    } catch (exception, stackTrace) {
      LoggerService.debugLog(exception: exception, stackTrace: stackTrace);
    }

    return list;
  }

  Future<List<VideoItem>> fetchVideos(
      {int itemCnt = 10, int? nextIndex, bool isRebuild = false}) async {
    FetchVideosResponse videoResponse =
        FetchVideosResponse(videos: [], limit: 0, next: 0);

    try {
      videoResponse = await  _videoRepository.fetchVideos(
          itemCnt: itemCnt, nextIndex: nextIndex, isRebuild: isRebuild);
    } catch (exception, stackTrace) {
      LoggerService.debugLog(exception: exception, stackTrace: stackTrace);
    }

    return videoResponse.videos;
  }

  bool isVideoLiked(String id) {
    return _likedVideos[id] != null;
  }

  Future<dynamic> toggleLikeVideo(
      {required VideoItem video, required bool isLiked}) async {
    try {
      await _videoRepository.toggleLikeVideo(id: video.id, isLiked: isLiked);
    } catch (exception, stackTrace) {
      LoggerService.debugLog(
        exception: exception,
        stackTrace: stackTrace,
      );
    }

    if (isLiked) {
      _likedVideos[video.id] = video;
    } else {
      _likedVideos.remove(video.id);
    }
  }

  void clearFetchedVideos() {
    _likedVideos.clear();
  }

  Future<SearchVideosResponse> searchVideos(
      {required String text, String? next}) async {
    SearchVideosResponse response =
        SearchVideosResponse(videos: [], limit: 0, next: 0);
    try {
      response = await _videoRepository.search(text: text, next: next);
    } catch (exception, stackTrace) {
      LoggerService.debugLog(exception: exception, stackTrace: stackTrace);
    }
    return response;
  }

  Future<FetchVideosResponse> fetchUserVideos(
      {required String userId, String next = '', int limit = 10}) async {
    // return FetchVideosResponse(videos: [], limit: 0, next: 0);
    FetchVideosResponse videoResponse =
        FetchVideosResponse(videos: [], limit: 0, next: 0);
    try {
      videoResponse = await _videoRepository.fetchUserVideos(
          userId: userId, limit: limit, nextIndex: next);
    } catch (exception, stackTrace) {
      LoggerService.debugLog(exception: exception, stackTrace: stackTrace);
    }

    return videoResponse;
  }

  Future<bool> incrementVideoViewCounter(String videoId) async {
    return await _videoRepository.sendView(videoId);
  }
}
