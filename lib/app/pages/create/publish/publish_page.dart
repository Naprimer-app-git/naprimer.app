import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:naprimer_app_v2/app/pages/create/publish/publish_controller.dart';
import 'package:naprimer_app_v2/app/utils/text_validator.dart';
import 'package:naprimer_app_v2/app/widgets/buttons/large_button.dart';
import 'package:naprimer_app_v2/app/widgets/text/styled_text_field.dart';

import '../create_controller.dart';

class PublishPage extends StatelessWidget {
  final CreateController createController;

  PublishPage(this.createController);

  @override
  Widget build(BuildContext context) {
    bool isKeyboardShown = MediaQuery.of(context).viewInsets.bottom != 0;
    return SafeArea(
      child: GetBuilder(
          init: PublishController(this.createController),
          builder: (PublishController controller) {
            return Scaffold(
              backgroundColor: Colors.black,
              appBar: AppBar(
                automaticallyImplyLeading: true,
                backgroundColor: Colors.black,
                centerTitle: true,
                title: Text('Details'),
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Form(
                        key: controller.formKey,
                        child: Column(
                          children: [
                            _buildPreview(context),
                            /*_buildChangePreviewBtn(controller),
                            const SizedBox(height: 32),*/
                            StyledTextField.standard(
                                controller: controller.titleEditingController,
                                labelText: 'Title',
                                keyboardType: TextInputType.text,
                                autoValidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: TextFieldValidator.title),
                            const SizedBox(height: 16),
                            StyledTextField.standard(
                                labelText: 'Description (optional)',
                                controller:
                                    controller.descriptionEditingController),
                            isKeyboardShown
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 48.0),
                                    child: _buildButtons(controller),
                                  )
                                : const SizedBox(height: 112)
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: !isKeyboardShown,
                      child: Align(
                          alignment: AlignmentDirectional.bottomCenter,
                          child: _buildButtons(controller)),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget _buildPreview(BuildContext context) {
    String? imagePath = Get.find<CreateController>().videoFile.imagePath;
    Widget imageWidget;
    if (imagePath == null) {
      imageWidget = Container(
        margin: EdgeInsets.only(top: 18, bottom: 16),
        height: Get.height / 2.5,
        child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            child: Image.file(
                File(imagePath!))),
      );
    } else {
      imageWidget = Text('no image preview, we need an image to show this');
    }

    return Align(alignment: AlignmentDirectional.center, child: imageWidget);
  }

  // Widget _buildChangePreviewBtn(PublishController controller) {
  //   return ButtonWrapper(
  //     onTap: controller.onChangePreviewPressed,
  //     child: Container(
  //       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  //       decoration: BoxDecoration(
  //           color: Color(0xff2D2D2D),
  //           borderRadius: BorderRadius.all(Radius.circular(12))),
  //       child: Text('Change preview picture'),
  //     ),
  //   );
  // }

  Widget _buildButtons(PublishController controller) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /* LargeButton(
          label: 'Unpublish',
          type: LargeButtonType.dark,
          onTap: controller.onUnpublishedPressed,
        ),
        const SizedBox(
          height: 8,
        ),*/
        LargeButton(
          label: 'Publish',
          onTap: controller.onPublishPressed,
        ),
      ],
    );
  }
}
