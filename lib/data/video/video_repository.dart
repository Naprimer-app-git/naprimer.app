import 'dart:async';
import 'dart:io';

import 'package:get/get_connect.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:naprimer_app_v2/app/config/network_service_config.dart';
import 'package:naprimer_app_v2/data/exception/like_exception.dart';
import 'package:naprimer_app_v2/data/exception/video_exception.dart';
import 'package:naprimer_app_v2/data/video/fetch_videos_response.dart';
import 'package:naprimer_app_v2/data/video/search_videos_response.dart';
import 'package:naprimer_app_v2/data/video/video_item.dart';
import 'package:naprimer_app_v2/domain/token/abstract_token.dart';
import 'package:naprimer_app_v2/domain/video/abstract_video_repository.dart';
import 'package:naprimer_app_v2/services/networking/abstract_network_service.dart';
import 'package:naprimer_app_v2/services/networking/dio_network_service.dart';
import 'package:naprimer_app_v2/services/networking/network_service.dart';
import 'package:naprimer_app_v2/services/user_controller.dart';

class VideoRepository implements AbstractVideoRepository {
  final NetworkService networkService;
  final VideoConfig config;

  VideoRepository({required this.networkService, required this.config});

  //todo itemCtn doesn't work, check backend
  @override
  Future<FetchVideosResponse> fetchVideos(
      {int itemCnt = 10, int? nextIndex, bool isRebuild = false}) async {
    Response response = await networkService.makeRequest(
      headers: await addAuthorizationHeaders({}),
      requestMethod: RequestMethod.GET,
      url: '${config.fetchVideos}',
      body: {
        'limit': itemCnt,
        'next': nextIndex?.toString() ?? '',
        'rebuild': isRebuild.toString()
      },
    );
    if (response.statusCode != 200) {
      throw FetchVideosException.fromResponse(response);
    }
    return FetchVideosResponse.fromJson(response.body, config.baseUrl);
  }

  @override
  Future<FetchVideosResponse> fetchUserVideos(
      {required String userId, int limit = 10, String nextIndex = ''}) async {
    Response response = await networkService.makeRequest(
      requestMethod: RequestMethod.GET,
      url: '${config.fetchUserVideos(userId)}',
      body: {
        'next': nextIndex,
        'limit': limit,
      },
    );
    if (response.statusCode != 200) {
      throw FetchVideosException.fromResponse(response);
    }
    return FetchVideosResponse.fromJson(response.body, config.baseUrl);
  }

  Future<bool> sendView(String videoId) async {
    Response response = await networkService.makeRequest(
      requestMethod: RequestMethod.POST,
      url: '${config.viewVideo(videoId)}',
      headers: await addAuthorizationHeaders({}),
    );

    if (response.statusCode != 204) {
      throw FetchVideosException.fromResponse(response);
    }

    return true;
  }

  @override
  Future<void> toggleLikeVideo(
      {required String id, required bool isLiked}) async {
    Response response = await networkService.makeRequest(
        url: config.likeVideo(id),
        headers: await addAuthorizationHeaders({}),

        requestMethod: isLiked ? RequestMethod.POST : RequestMethod.DELETE);
    if (response.statusCode == 200 || response.statusCode == 204) {
    } else {
      throw LikeException.fromResponse(response);
    }
  }

  //todo fix so video repo should return only response objects
  @override
  Future<List<VideoItem>> fetchLikedVideos(
      {required String userId, String next = '', int limit = 10}) async {
    Response response = await networkService.makeRequest(
        url: '/profiles/$userId/reactions',
        headers: await addAuthorizationHeaders({}),

        //todo for debug purposes
        query: {'limit': limit.toString(), 'next': next, 'type': 'likes'},
        requestMethod: RequestMethod.GET);
    if (response.body['results'] != null) {
      List<dynamic> jsonList = response.body['results'];
      return jsonList
          .map((json) => VideoItem.fromJson(json, config.baseUrl))
          .toList();
    } else {
      return [];
    }
  }

  @override
  Future<SearchVideosResponse> search(
      {required String text, String? next}) async {
    Response response = await networkService.makeRequest(
        url: config.searchVideos,
        query: {'text': text, 'limit': '10', 'next': next ?? ''},
        requestMethod: RequestMethod.GET);
    if (response.statusCode != 200) {
      throw FetchVideosException.fromResponse(response);
    }

    return SearchVideosResponse.fromJson(response.body, config.baseUrl);
  }

  Future<VideoItem> create() async {
    Response response = await networkService.makeRequest(
        url: config.modifyVideo,
        headers: await addAuthorizationHeaders({}),
        requestMethod: RequestMethod.POST);
    if (response.statusCode != 200) {
      throw FetchVideosException.fromResponse(response); //Todo
    }

    return VideoItem.fromJson(response.body, config.baseUrl);
  }

  Future<bool> delete({required String id}) async {
    Response response = await networkService.makeRequest(
        url: "${config.modifyVideo}/$id",
        headers: await addAuthorizationHeaders({}),
        requestMethod: RequestMethod.POST);

    return response.statusCode == 204;
  }

  Future<bool> upload(
      {required String id,
      required String url,
      required String filePath}) async {

    File video = File(filePath);

    final length = video.lengthSync();

    print('VIDEO CONTENT_LENGTH $length');

    //Todo: Никакие комбинации не позволили мне выгрузить видео используя GetConnect
    //Фактически стоит вопрос в отказе от него как по мне ибо это не прикольно

    var response = await DioNetworkService().makeRequest(
        url: url, //url.replaceAll("https", "http"),
        contentType: 'video/mp4',
        headers: {
          HttpHeaders.contentLengthHeader: length.toString(),
          HttpHeaders.contentRangeHeader: 'bytes 0-$length/$length',
          HttpHeaders.contentTypeHeader: 'video/mp4'
        },
        body: video.openRead(),
        requestMethod: RequestMethod.PUT,
        /*uploadProgress: (double percent) {
          print(percent);
        }*/);


    return response.statusCode == 200;
  }

  Future<VideoItem> update(
      {required String id, String? title, String? description}) async {
    Response response = await networkService.makeRequest(
        url: "${config.modifyVideo}/$id",
        body: {
          'title': title,
          'description': description,
          'publish_after_upload': "true"
        },
        headers: await addAuthorizationHeaders({}),
        requestMethod: RequestMethod.PATCH);
    if (response.statusCode != 200) {
      throw FetchVideosException.fromResponse(response);
    }

    return VideoItem.fromJson(response.body, config.baseUrl);
  }

  Future<Map<String, String>> addAuthorizationHeaders(
      Map<String, String>? headers) async {
    AbstractToken? token = await Get.find<UserController>().getToken() ?? null;
    if (headers == null) headers = {};
    if (token != null) {
      headers.addAll({"Authorization": 'Bearer ${token.accessToken}'});
    }
    return headers;
  }
}
