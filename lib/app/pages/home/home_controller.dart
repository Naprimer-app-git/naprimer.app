import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:naprimer_app_v2/app/pages/app_controller.dart';
import 'package:naprimer_app_v2/app/pages/for_you/for_you_root.dart';
import 'package:naprimer_app_v2/app/pages/home/bottom_nav_bar_menu.dart';
import 'package:naprimer_app_v2/app/pages/home/home_page_arguments.dart';
import 'package:naprimer_app_v2/app/pages/profile/personal/personal_profile_page.dart';
import 'package:naprimer_app_v2/app/pages/search/search_root.dart';
import 'package:naprimer_app_v2/app/routing/pages.dart';
import 'package:naprimer_app_v2/domain/user/abstract_user.dart';

class HomeController extends GetxController {
  final HomePageArguments? arguments;
  late List<Widget> _tabs;
  late AppController _appController;
  DateTime? currentBackPressTime;

  HomeController({this.arguments});

  List<Widget> get tabs => _tabs;
  late int _selectedIndex;

  int get selectedIndex => _selectedIndex;

  AbstractUser? get user => _appController.user;

  @override
  void onInit() {
    super.onInit();
    _appController = Get.find<AppController>();
    _tabs = [ForYouRoot(), Container(), SearchRoot(), PersonalProfilePage()];
  }

  @override
  InternalFinalCallback<void> get onStart {
    _selectedIndex = arguments?.selectedTab?.index ?? 0;
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      update();
    });
    return super.onStart;
  }

  void onItemTapped(int index) {
    switch (index) {
      case 0:
        navigateToInitialForYou();
        break;
      case 2:
        navigateToIndex(index);
        break;
      case 1:
        navigateToIndex(BottomNavBarMenu.ForYou.index);
        Get.toNamed(_appController.user == null ? Routes.AUTH : Routes.CREATE);
        break;
      case 3:
        if (_appController.user == null) {
          if (_selectedIndex != BottomNavBarMenu.ForYou.index) {
            navigateToIndex(BottomNavBarMenu.ForYou.index);
          }
          Get.toNamed(Routes.AUTH);
        } else {
          navigateToIndex(index);
        }
        break;
    }
  }

  void navigateToIndex(int index) {
    _selectedIndex = index;
    update();
  }

  void navigateToInitialForYou() {
    Get.nestedKey(ForYouPages.navigatorKeyId)!.currentState?.popUntil((route) {
      var currentRoute = route.settings.name ?? 'no current route';
      return currentRoute == Routes.FOR_YOU;
    });
    _selectedIndex = 0;
    update();
  }

  Future<bool> onBackPressed(BuildContext context) async {
    if (selectedIndex == 0) {
      _navigateBackFromForYouTab(context);
    } else if (selectedIndex == 2) {
      _navigateBackFromSearchTab();
    } else {
      Get.key.currentState?.popUntil((route) {
        var currentRoute = route.settings.name ?? 'no current route';
        if (currentRoute == Routes.SIGN_UP) {
          Get.back();
        }
        return true;
      });
    }

    if (_selectedIndex == 1) {
      onItemTapped(0);
    }
    return false;
  }

  void _navigateBackFromForYouTab(BuildContext context) {
    Get.nestedKey(ForYouPages.navigatorKeyId)!.currentState?.popUntil((route) {
      var currentRoute = route.settings.name ?? 'no current route';
      if (currentRoute == Routes.GENERAL_PROFILE) {
        Get.back(id: ForYouPages.navigatorKeyId);
      }
      if (currentRoute == Routes.FOR_YOU) {
        DateTime now = DateTime.now();
        if (currentBackPressTime == null ||
            now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
          currentBackPressTime = now;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              duration: Duration(seconds: 2),
              backgroundColor: Colors.black,
              content: Container(
                color: Colors.black,
                child: Text(
                  'Press back again to exit',
                  style: TextStyle(color: Colors.white),
                ),
              )));
        } else {
          SystemNavigator.pop();
        }
      }
      return true;
    });
  }

  void _navigateBackFromSearchTab() {
    Get.nestedKey(SearchPages.navigatorKeyId)!.currentState?.popUntil((route) {
      var currentRoute = route.settings.name ?? 'no current route';
      if (currentRoute == Routes.GENERAL_PROFILE) {
        Get.back(id: SearchPages.navigatorKeyId);
      }
      return true;
    });
  }
}
