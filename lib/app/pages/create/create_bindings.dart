import 'package:get/get.dart';
import 'package:naprimer_app_v2/data/video/video_repository.dart';
import 'package:naprimer_app_v2/app/config/network_service_config.dart';
import 'package:naprimer_app_v2/services/encoding/encoding_service.dart';
import 'package:naprimer_app_v2/services/networking/network_service.dart';

import 'camera/camera_view_controller.dart';
import 'create_controller.dart';

class CreateBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EncodingService());
    Get.lazyPut(() => VideoRepository(
        networkService: Get.find<NetworkService>(), config: VideoConfig()));
    Get.lazyPut(() => CreateController());
  }
}