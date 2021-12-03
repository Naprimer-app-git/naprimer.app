import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naprimer_app_v2/app/config/camera_config.dart';
import 'package:naprimer_app_v2/app/routing/pages.dart';
import 'package:naprimer_app_v2/data/video/video_item.dart';
import 'package:naprimer_app_v2/data/video/video_repository.dart';
import 'package:naprimer_app_v2/domain/file/created_file.dart';
import 'package:naprimer_app_v2/services/logger/logger_service.dart';

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

  Future<void> onPublishPressed(BuildContext context) async {
    try {
      if (formKey.currentState!.validate()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.transparent,
            content: Container(
              padding: EdgeInsets.all(18),
              margin: EdgeInsets.only(bottom: 24, left: 24, right: 24),
              child: Text(
                'Video is uploading...',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              decoration: BoxDecoration(
                  color: Color(0xE63B3B3B),
                  borderRadius: BorderRadius.all(Radius.circular(24.0))),
            ),
          ),
        );
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
    } catch (exception, stackTrace) {
      LoggerService.debugLog(
        exception: exception,
        stackTrace: stackTrace,
      );
    }
  }

  void showEmptyTitleError() {
    _isErrorMessageShown = true;
    update(['error_part']);
  }
}
