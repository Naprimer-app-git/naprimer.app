import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'create_controller.dart';

class CreatePage extends GetView<CreateController> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: controller.onBackPressed,
        child: SafeArea(
          child: Stack(
            children: [
              GetBuilder(builder: (CreateController controller) {
                return PageView.builder(
                  controller: controller.pageController,
                  onPageChanged: controller.onPageChanged,
                  itemCount: controller.pagesLength.value,
                  itemBuilder: (BuildContext context, int itemIndex) {
                    return controller.pages[itemIndex];
                  },
                );
              })
            ],
          ),
        ));
  }
}
