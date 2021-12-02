import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:naprimer_app_v2/app/pages/create/camera/camera_view.dart';
import 'package:naprimer_app_v2/app/routing/pages.dart';
import 'package:naprimer_app_v2/domain/pages/focusable.dart';
import 'package:naprimer_app_v2/app/pages/create/preview/preview_page.dart';
import 'package:naprimer_app_v2/app/pages/create/publish/publish_page.dart';
import 'package:naprimer_app_v2/domain/file/created_file.dart';

class CreateController extends GetxController {
  late PageController _pageController;
  final int initialPage = 0;
  late int currentPage;

  late CreatedFile videoFile;
  late List<Widget> pages;

  bool _isPreviewPageUnlocked = false;
  bool _isPublishPageUnlocked = false;


  RxInt get pagesLength => _calculatePagesLength().obs;

  PageController get pageController => _pageController;

  @override
  void onInit() {
    pages = [CameraView(this), PreviewPage(this), PublishPage(this)];
    _pageController = PageController(initialPage: initialPage, keepPage: false);
    currentPage = initialPage;

    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
      ],
    );

    super.onInit();
  }

  @override
  void onClose() {
    currentPage = 0;
    _isPreviewPageUnlocked = false;
    _isPublishPageUnlocked = false;

    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ],
    );
    super.onClose();
  }

  onPageChanged(int index) {
    currentPage = index;
    for (int i = 0; i < pages.length; i++) {
      var page = pages[i];
      if (page is Focusable)
        (page as Focusable).onFocusChanged(inFocus: i == currentPage);
    }
  }

  Future<void> onClosePressed() async {
    if (currentPage > 0) {
      onBackPressed();
    } else {
      Get.offAndToNamed(Routes.HOME);
    }
  }

  //Todo: нужно бы реализовать попап delete и единую логику close ы учетом PageView
  Future<bool> onBackPressed() async {
    if (currentPage > 0) {
      _pageController.previousPage(
          duration: Duration(milliseconds: 200), curve: Curves.ease);
      return false;
    } else {
      return true;
    }
  }

  Future<void> navigateToPreviewPage(CreatedFile videoFile) async {
    this.videoFile = videoFile;
    _isPreviewPageUnlocked = true;
    await this.videoFile.generateThumbnail();
    update();
    _pageController.nextPage(
        duration: Duration(milliseconds: 200), curve: Curves.ease);
  }

  Future<void> navigateToPublishPage() async {
    _isPublishPageUnlocked = true;
    update();
    _pageController.nextPage(
        duration: Duration(milliseconds: 200), curve: Curves.ease);
  }


  int _calculatePagesLength() {
    int pages = 1;
    if (_isPreviewPageUnlocked) pages++;
    if (_isPublishPageUnlocked) pages++;
    return pages;
  }
}
