import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:naprimer_app_v2/app/widgets/buttons/button_wrapper.dart';
import 'package:naprimer_app_v2/app/widgets/video/preview_video.dart';

import '../create_controller.dart';

class PreviewPage extends GetView<CreateController> {
  final CreateController createController;

  PreviewPage(this.createController);

  @override
  Widget build(BuildContext context) {
    closeKeyboardIfNeeded(context);
    return SafeArea(
      child: Material(
        child: Stack(
          children: [
            PreviewVideo(
                config: PreviewConfig(
              videoUrl: controller.videoFile.videoPath,
              isSoundEnabled: true,
                  previewImagePath: createController.videoFile.imagePath ?? ''
            )),
            Align(
              alignment: AlignmentDirectional.topStart,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ButtonWrapper(
                    onTap: controller.onClosePressed, child: Icon(Icons.close)),
              ),
            ),
            Align(
                alignment: AlignmentDirectional.bottomCenter,
                child: _buildPublishButton())
          ],
        ),
      ),
    );
  }

  Widget _buildPublishButton() {
    return ButtonWrapper(
      onTap: createController.navigateToPublishPage,
      child: Container(
        margin: const EdgeInsets.only(bottom: 58.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.arrow_upward_outlined),
            SizedBox(height: 6),
            Text('Publish')
          ],
        ),
        width: 92,
        height: 92,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(92)),
          color: Color(0xff0C48FF),
        ),
      ),
    );
  }

  void closeKeyboardIfNeeded(BuildContext context) {
    bool isKeyboardShown = MediaQuery.of(context).viewInsets.bottom != 0;
    if (isKeyboardShown) FocusScope.of(context).unfocus();
  }
}
