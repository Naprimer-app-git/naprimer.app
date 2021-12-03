import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:naprimer_app_v2/app/pages/create/create_controller.dart';
import 'package:naprimer_app_v2/domain/file/created_file.dart';
import 'package:naprimer_app_v2/services/camera/camera_service.dart';
import 'package:naprimer_app_v2/services/encoding/encoding_service.dart';
import 'package:naprimer_app_v2/services/logger/logger_service.dart';
import 'package:wakelock/wakelock.dart';

class CameraViewController extends GetxController {
  final CreateController createController;

  late CameraService _camera;
  late CreatedFile _videoFile;

  CameraState get state => _camera.state.value;

  Widget get cameraPreview => _camera.cameraPreview;

  CreatedFile get videoFile => _videoFile;

  double get aspectRatio => _camera.aspectRatio;

  double get recordingProgress => _camera.recordedProgress;

  CameraViewController(this.createController);

  Size? get previewSize => _camera.previewSize;

  @override
  void onInit() {
    _camera = Get.find<CameraService>();
    super.onInit();
  }

  @override
  void onReady() {
    Wakelock.enable();
    _camera.create();
    _camera.recordedProgressStream.listen((recordingProgress) {
      if (recordingProgress == 1.0) {
        recordingIsOnTheLimit();
      }
    });
    super.onReady();
  }

  @override
  void onClose() {
    Wakelock.disable();
    _camera.reset();
    super.onClose();
  }

  void onFocusChanged(bool inFocus) {
    if (!_camera.initialized) return;
    if (_camera.isClosed) return;
    inFocus ? onReady() : onClose();
  }

  void onPauseRecordPressed() {
    _camera.pauseRecording();
  }

  void onStartRecordPressed() {
    if (state == CameraState.READY) {
      _camera.startRecording();
    } else if (state == CameraState.PAUSED) {
      _camera.resumeRecording();
    } else {
      //Todo
    }
  }

  Future<void> onToggleCameraPressed() async {
    _camera.toggleCamera();
  }

  Future<void> recordingIsOnTheLimit() async {
    await generateFileFromCamera();
    createController.navigateToPreviewPage(_videoFile);
  }

  Future<void> onNextPressed(
      {String fileName = '', String filePath = ''}) async {
    if (filePath.isEmpty) {
      await generateFileFromCamera();
    } else {
      generateFileFromGallery(fileName, filePath);
    }

    createController.navigateToPreviewPage(_videoFile);
  }

  void generateFileFromGallery(String fileName, String filePath) {
    try {
      _videoFile =
          CreatedFile(fileName, filePath, null, Get.find<EncodingService>());
    } catch (exception, stackTrace) {
      LoggerService.debugLog(
        exception: exception,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> generateFileFromCamera() async {
    try {
      await _camera.stopRecording();
      _videoFile = CreatedFile(_camera.videoFile!.name, _camera.videoFile!.path,
          null, Get.find<EncodingService>());
      _videoFile.name = _camera.videoFile!.name;
      _videoFile.videoPath = _camera.videoFile!.path;
    } catch (exception, stackTrace) {
      LoggerService.debugLog(
        exception: exception,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> onClosePressed() async {
    try {
      await _camera.reset();
      createController.onClosePressed();
    } catch (exception, stackTrace) {
      LoggerService.debugLog(
        exception: exception,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> onUploadFromGalleryPressed() async {
    try {
      await _camera.reset();
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.video);

      if (result != null) {
        PlatformFile file = result.files.first;
        onNextPressed(fileName: file.name, filePath: file.path ?? "");
      } else {
        _camera.create();
      }
    } catch (exception, stackTrace) {
      LoggerService.debugLog(
        exception: exception,
        stackTrace: stackTrace,
      );
    }
  }
}
