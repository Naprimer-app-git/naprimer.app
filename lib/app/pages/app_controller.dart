import 'dart:async';

import 'package:get/get.dart';
import 'package:naprimer_app_v2/app/config/network_service_config.dart';
import 'package:naprimer_app_v2/app/routing/pages.dart';
import 'package:naprimer_app_v2/data/user/user_repository.dart';
import 'package:naprimer_app_v2/data/video/video_repository.dart';
import 'package:naprimer_app_v2/domain/token/abstract_token.dart';
import 'package:naprimer_app_v2/domain/user/abstract_user.dart';
import 'package:naprimer_app_v2/services/logger/logger_service.dart';
import 'package:naprimer_app_v2/services/networking/network_client.dart';
import 'package:naprimer_app_v2/services/networking/network_service.dart';
import 'package:naprimer_app_v2/services/storage/db_client.dart';
import 'package:naprimer_app_v2/services/storage/db_service.dart';
import 'package:naprimer_app_v2/services/user_controller.dart';
import 'package:naprimer_app_v2/services/video/video_controller.dart';

import 'create/create_controller.dart';

class AppController extends GetxController {
  late bool isInited;
  late bool isTimerIsOut;
  final int splashScreenShownDuration = 1;

  late UserController _userController;
  late VideoController _videoController;

  AbstractUser? user;
  AbstractToken? token;

  VideoController get videoController => _videoController;

  @override
  void onInit() {
    isInited = false;
    isTimerIsOut = false;
    Timer(Duration(seconds: splashScreenShownDuration), () {
      isTimerIsOut = true;
      navigateNextIfReady();
    });

    super.onInit();
  }

  @override
  void onReady() async {
    await initServices();
    user = _userController.user.value;
    await initialFetchForVideoController();
    addUserAuthListener();
    isInited = true;
    navigateNextIfReady();
    super.onReady();
  }

  Future<void> initialFetchForVideoController() async {
    if (user != null) {
      await _videoController.fetchUserLikedVideos(userId: user!.id);
    }
  }

  void addUserAuthListener() {
    _userController.user.listen((user) {
      this.user = user;
      if (user == null) {
        _videoController.clearFetchedVideos();
      } else {
        _videoController.fetchUserLikedVideos(userId: this.user!.id);
      }
    });
  }

  Future<void> initServices() async {
    try {
      await Get.putAsync(() => initNetworkService(), permanent: true);
      await Get.putAsync(() => initDbService(), permanent: true);
      await Get.putAsync(() => initUserController(), permanent: true);
      await _userController.loadUser();
      await checkUserInBackend();
      initVideoController();
      initCreateController();
    } catch (exception, stackTrace) {
      LoggerService.debugLog(exception: exception, stackTrace: stackTrace);
    }
  }

  Future<NetworkService> initNetworkService() async {
    return await Get.putAsync(
            () => NetworkService().init(
            networkClient: NetworkClient(), config: NetworkServiceConfig()),
        permanent: true);
  }

  Future<DbService> initDbService() async {
    DbClient dbClient = DbClient();
    return DbService(client: await dbClient.init());
  }

  Future<UserController> initUserController() async {
    UserRepository _userRepository = UserRepository(
        Get.find<DbService>(), Get.find<NetworkService>(), UserConfig());
    _userController = UserController(_userRepository);
    return _userController;
  }

  //Todo: delete after active development
  Future<AbstractUser?> checkUserInBackend() async {
    if (_userController.user.value != null) {
      _userController.userRepository
          .findUserById(_userController.user.value!.id)
          .then((value) => value)
          .catchError((onError) {
            _userController.logout();
      });
    }
  }

  void initVideoController() {
    Get.put<VideoRepository>(VideoRepository(
        networkService: Get.find<NetworkService>(), config: VideoConfig()), permanent: true);
    _videoController =
        Get.put<VideoController>(VideoController(), permanent: true);
  }

  void initCreateController() {
    Get.put(CreateController(), permanent: false);
  }

  void navigateNextIfReady() {
    if (isInited && isTimerIsOut) {
      Get.offAndToNamed(Routes.HOME);
    }
  }
}
