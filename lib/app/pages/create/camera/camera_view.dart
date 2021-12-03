import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naprimer_app_v2/app/pages/create/camera/camera_view_controller.dart';
import 'package:naprimer_app_v2/app/pages/create/camera/widget/camera_controls_panel.dart';
import 'package:naprimer_app_v2/app/utils/constants.dart';
import 'package:naprimer_app_v2/app/widgets/buttons/button_wrapper.dart';
import 'package:naprimer_app_v2/services/camera/camera_service.dart';

import '../../../../domain/pages/focusable.dart';
import '../create_controller.dart';

class CameraView extends StatefulWidget {
  final CreateController createController;

  CameraView(this.createController);

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> with WidgetsBindingObserver  implements Focusable {

  void onFocusChanged({required bool inFocus}) {
    Get.find<CameraViewController>().onFocusChanged(inFocus);
  }

  @override
  Widget build(BuildContext context) {
    closeKeyboardIfNeeded(context);
    return GetBuilder(
        init: CameraViewController(this.widget.createController),
        global: true,
        autoRemove: false,
        builder: (CameraViewController controller) {
          return Scaffold(
            body: Center(
              child: Obx(
                () => controller.state != CameraState.INIT
                    ? Stack(children: [
                        LayoutBuilder(builder:
                            (BuildContext context, BoxConstraints constraints) {
                          final double deviceRatio = context.width / (context.height);
                          final previewHeight = controller.previewSize?.height ?? 1.0;
                          final previewWidth = controller.previewSize?.width ?? 1.0;
                          final double xScale = ( previewHeight/previewWidth) / deviceRatio;
                          // Modify the yScale if you are in Landscape
                          final yScale = 1.0;
                          return AspectRatio(
                            aspectRatio: deviceRatio,
                            child: Transform(
                                alignment: Alignment.center,
                                transform:
                                    Matrix4.diagonal3Values(xScale, yScale, 0),
                                child: controller.cameraPreview),
                          );
                        }),
                        Align(
                          alignment: AlignmentDirectional.topStart,
                          child: Padding(
                            padding: const EdgeInsets.all(defaultPadding),
                            child: ButtonWrapper(
                                onTap: controller.onClosePressed,
                                child: Icon(Icons.close)),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional.bottomCenter,
                          child: CameraControlsPanel(
                            controller: controller,
                          ),
                        )
                      ])
                    : CircularProgressIndicator(),
              ),
            ),
          );
        });
  }

  void closeKeyboardIfNeeded(BuildContext context) {
    bool isKeyboardShown = MediaQuery.of(context).viewInsets.bottom != 0;
    if (isKeyboardShown) FocusScope.of(context).unfocus();
  }
}
