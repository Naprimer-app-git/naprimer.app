import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:naprimer_app_v2/app/pages/create/camera/camera_view_controller.dart';
import 'package:naprimer_app_v2/services/camera/camera_service.dart';

import 'camera_control.dart';

class CameraControlsPanel extends StatelessWidget {
  final CameraViewController controller;

  const CameraControlsPanel(
      {Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [_buildBody(), _buildProgressBar(), const SizedBox(height: 24)],
    );
  }

  Widget _buildBody() {
    switch (controller.state) {
      case CameraState.READY:
        return _buildReadyToStartRecordingPanel();
      case CameraState.RECORDING:
        return _buildRecordingPanel();
      case CameraState.PAUSED:
        return _buildPausedPanel();
      default:
        return Container();
    }
  }

  Widget _buildProgressBar() {
    switch (controller.state) {
      case CameraState.READY:
        return const SizedBox(height: 20);
      case CameraState.RECORDING:
      case CameraState.PAUSED:
      case CameraState.READY_TO_PUBLISH:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 46),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            child: Obx(()=>LinearProgressIndicator(
              color: Color(0xff0C48FF),
              value: controller.recordingProgress,
              minHeight: 10,
              // valueColor:<Color>(Color(0xff0C48FF)),
              backgroundColor: Colors.grey.withOpacity(0.3),
            ),
            )
          ),
        );
      default:
        return Center(
          child: CircularProgressIndicator(),
        );
    }
  }

  Widget _buildReadyToStartRecordingPanel() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CameraControlBuilder.buildToggleCameraControl(
            onTap: controller.onToggleCameraPressed),
        CameraControlBuilder.buildStartRecordControl(
            onTap: controller.onStartRecordPressed),
        CameraControlBuilder.buildUploadFromGalleryControl(
            onTap: controller.onUploadFromGalleryPressed),
      ],
    );
  }

  Widget _buildRecordingPanel() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CameraControlBuilder.buildPauseRecordControl(
            onTap: controller.onPauseRecordPressed),
      ],
    );
  }

  Widget _buildPausedPanel() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(width: 48),
        CameraControlBuilder.buildStartRecordControl(
            onTap: controller.onStartRecordPressed),
        CameraControlBuilder.buildNextControl(onTap: controller.onNextPressed),
      ],
    );
  }
}
