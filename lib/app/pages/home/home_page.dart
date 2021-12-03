import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naprimer_app_v2/app/pages/home/bottom_nav_bar_menu.dart';
import 'package:naprimer_app_v2/app/styling/assets.dart';

import 'home_controller.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<HomeController>(builder: (controller) {
        return WillPopScope(
          onWillPop: () => controller.onBackPressed(context),
          child: SafeArea(
            child: Scaffold(
              body: NotificationListener(
                onNotification: (ss) {
                  return true;
                },
                child: IndexedStack(
                    index: controller.selectedIndex, children: controller.tabs),
              ),
              bottomNavigationBar: _buildBottomNavigationBar(controller),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildBottomNavigationBar(HomeController controller) {
    return Visibility(
      visible: controller.selectedIndex != BottomNavBarMenu.Create.index,
      child: BottomNavigationBar(
        items: _buildItems(controller),
        currentIndex: controller.selectedIndex,
        onTap: (index) => controller.onItemTapped(index),
      ),
    );
  }

  List<BottomNavigationBarItem> _buildItems(HomeController controller) {
    return BottomNavBarMenu.values
        .map((item) => BottomNavigationBarItem(
              activeIcon: getIcon(item, controller),
              icon: getIcon(item, controller),
              label: item.label,
            ))
        .toList();
  }

  Widget getIcon(BottomNavBarMenu item, HomeController controller) {
    if (item == BottomNavBarMenu.Profile && controller.user != null) {
      return ClipRect(
          child: Image.asset(
        Assets.defaultAvatar,
        height: 24,
        width: 24,
      ));
    } else {
      return Icon(item.icon);
    }
  }
}
