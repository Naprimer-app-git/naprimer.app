import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:naprimer_app_v2/app/config/camera_config.dart';

enum CameraState {
  INIT,
  READY,
  RECORDING,
  RECORDED,
  PAUSED,
  READY_TO_PUBLISH,
  DISPOSE,
  ERROR
}

class CameraService extends GetxService {
  late List<CameraDescription> _cameras;
  late CameraController? _cameraController;
  late CameraPreview? _cameraPreview;
  late Timer? _recordingTimer;

  late XFile _imagePreview;

  XFile? _videoFile;
  var _state = CameraState.INIT.obs;
  var _recordedSeconds = 0.obs;
  var _recordedProgress = 0.0.obs;

  int _currentCameraId = 0;

  Widget get cameraPreview => _cameraPreview ?? Container();

  Rx<CameraState> get state => _state;

  XFile? get videoFile => _videoFile;
  XFile get preview => _imagePreview;

  double get aspectRatio => _cameraController?.value.aspectRatio ?? 1;

  Size? get previewSize => _cameraController?.value.previewSize;

  double get recordedProgress => _recordedProgress.value;
  RxDouble get recordedProgressStream => _recordedProgress;

  @override
  void onInit() {
     availableCameras().then((value) {
       _cameras = value;
     });

     super.onInit();
  }

  Future<CameraState> create() async {
    _cameraController =
        CameraController(_cameras[_currentCameraId], CAMERA_RESOLUTION_PRESET);

    try {
      await _cameraController?.initialize();
      _cameraPreview = CameraPreview(_cameraController!);
      _state.value = CameraState.READY;
    } on CameraException catch (e) {
      print(e); //Todo
      _state.value = CameraState.ERROR;
    }

    _recordedSeconds.value = 0;
    _recordedProgress.value = 0.0;

    return state.value;
  }

  Future<CameraState> reset() async {
    _cameraPreview = null;
    _cameraController?.dispose();
    _currentCameraId = 0;
    _state.value = CameraState.INIT;
    return state.value;
  }

  Future<CameraState> toggleCamera() async {
    _currentCameraId = _currentCameraId == 0 ? 1 : 0;
    _cameraPreview = null;
    return await create();
  }

  Future<CameraState> startRecording() async {
    if(_videoFile != null) {
      try {
        File original = File(_videoFile!.path);
        await original.delete();
      } catch (e) {

      }
    }

    if (state.value == CameraState.READY)
      try {
        //_imagePreview = (await _cameraController?.takePicture())!;
        await _cameraController?.startVideoRecording();
        _state.value = CameraState.RECORDING;
        _recordingTimer =
            new Timer.periodic(Duration(seconds: 1), _onRecordTimeChanged);
      } on CameraException catch (e) {
        print(e); //Todo
        _state.value = CameraState.ERROR;
      }
    return state.value;
  }

  Future<CameraState> stopRecording() async {
    if (_cameraController!.value.isRecordingVideo) {
      try {
        _videoFile = (await _cameraController?.stopVideoRecording())!;
        _state.value = CameraState.RECORDED;
        _recordingTimer?.cancel();
      } on CameraException catch (e) {
        print(e); //Todo
        _state.value = CameraState.ERROR;
      }
    }
    return state.value;
  }

  Future<CameraState> pauseRecording() async {
    if (state.value == CameraState.RECORDING)
      try {
        await _cameraController?.pauseVideoRecording();
        _state.value = CameraState.PAUSED;
        _recordingTimer?.cancel();
      } on CameraException catch (e) {
        print(e); //Todo
        _state.value = CameraState.ERROR;
      }
    //update();
    return state.value;
  }

  Future<CameraState> resumeRecording() async {
    if (state.value == CameraState.PAUSED)
      try {
        await _cameraController?.resumeVideoRecording();
        _state.value = CameraState.RECORDING;
        _recordingTimer =
            new Timer.periodic(Duration(seconds: 1), _onRecordTimeChanged);
      } on CameraException catch (e) {
        print(e); //Todo
        _state.value = CameraState.ERROR;
      }
    return state.value;
  }

  void _onRecordTimeChanged(Timer timer) {
    _recordedSeconds.value++;
    _recordedProgress.value = _recordedSeconds / MAX_RECORDING_DURATION;
    _recordedProgress.refresh();
  }
}
