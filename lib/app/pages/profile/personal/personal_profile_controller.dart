import 'dart:ui';

import 'package:get/get.dart';
import 'package:naprimer_app_v2/app/pages/app_controller.dart';
import 'package:naprimer_app_v2/app/routing/pages.dart';
import 'package:naprimer_app_v2/app/styling/app_colors.dart';
import 'package:naprimer_app_v2/app/styling/assets.dart';
import 'package:naprimer_app_v2/domain/user/abstract_user.dart';
import 'package:naprimer_app_v2/services/user_controller.dart';

class PersonalProfileController extends GetxController {
  late AppController _appController;
  late UserController _userController;

  late AbstractUser? _user;

  AbstractUser? get user => _user;

  bool get isAuth => _appController.user != null;

  final String _defaultAvatar = Assets.defaultAvatar;

  // not sure if this logic is correct
  String get userName {
    if(_user == null) return '';
    if (_user!.nickname != null) {
      return _user!.nickname!.isEmpty ? _user!.name : _user!.nickname!;
    } else {
      return _user!.name;
    }
  }

  String get avatar => _user?.avatar ?? _defaultAvatar;

  // not sure where I should take from a bg color;
  Color? get backgroundColor => AppColors.backgroundDefaultProfileColor;

  @override
  void onInit() {
    this._userController = Get.find<UserController>();
    this._appController = Get.find<AppController>();
    _user = _userController.user.value;
    _userController.user.listen((userValue) {
      if(userValue != null){
        _user = userValue;
        update();
      }
    });
    super.onInit();
  }

  void onSettingsPressed() {
    Get.toNamed(Routes.SETTINGS);
  }
}
