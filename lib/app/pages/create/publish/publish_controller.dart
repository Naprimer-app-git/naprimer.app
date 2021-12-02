import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:naprimer_app_v2/app/config/camera_config.dart';
import 'package:naprimer_app_v2/app/routing/pages.dart';
import 'package:naprimer_app_v2/data/video/video_item.dart';
import 'package:naprimer_app_v2/data/video/video_repository.dart';
import 'package:naprimer_app_v2/domain/file/created_file.dart';

import '../create_controller.dart';

class PublishController extends GetxController {
  final CreateController createController;

  VideoItem? _videoItem;
  VideoRepository _videoRepository = Get.find<VideoRepository>();

  late TextEditingController titleEditingController;
  late TextEditingController descriptionEditingController;
  bool _isErrorMessageShown = false;

  bool get isErrorMessageShown => _isErrorMessageShown;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  GlobalKey<FormState> get formKey => _formKey;

  PublishController(this.createController);

  @override
  void onInit() {
    titleEditingController = TextEditingController();
    descriptionEditingController = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    titleEditingController.dispose();
    descriptionEditingController.dispose();
    super.onClose();
  }

  void onChangePreviewPressed() {}

  void onUnpublishedPressed() {}

  Future<void> onPublishPressed() async {
    if (formKey.currentState!.validate()) {
      Get.offAndToNamed(Routes.HOME);

      CreatedFile file = createController.videoFile;
      await file.encode(true, CAMERA_RECTANGLE_MODE);

      _videoItem = await _videoRepository.create();

      await _videoRepository.update(
          id: _videoItem!.id,
          title: titleEditingController.text,
          description: descriptionEditingController.text);

      await _videoRepository.upload(
          id: _videoItem!.id,
          url: _videoItem!.upload?.url ?? "",
          filePath: file.videoPath);
    }
  }

  void showEmptyTitleError() {
    _isErrorMessageShown = true;
    update(['error_part']);
  }
}
