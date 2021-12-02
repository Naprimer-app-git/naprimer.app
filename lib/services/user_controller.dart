import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:naprimer_app_v2/domain/token/abstract_token.dart';
import 'package:naprimer_app_v2/domain/user/abstract_user.dart';
import 'package:naprimer_app_v2/domain/user/abstract_user_repository.dart';
import 'package:naprimer_app_v2/services/logger/logger_service.dart';

class UserController extends ChangeNotifier{
  late Rx<AbstractUser?> user;
  final AbstractUserRepository userRepository;

  UserController(this.userRepository);


  Future<void> saveUser(AbstractUser user) async {
    await userRepository.saveUser(user);
    this.user.value = user;
  }

  Future<void> loadUser() async {
    try{
      user = (await userRepository.loadUser()).obs;
      this.user = user;
    }catch (exception, stackTrace) {
      this.user = null.obs;
      LoggerService.debugLog(
        exception: exception,
        stackTrace: stackTrace,
      );
    }

  }

  Future<void> updateUser(AbstractUser user) async {
    try{
      await userRepository.updateUser(user);

    }catch (exception, stackTrace) {
      LoggerService.debugLog(
        exception: exception,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> logout() async {
    await userRepository.logout();
    this.user.value = null;
  }

  Future<void> saveToken(AbstractToken token) async {
    await userRepository.saveToken(token);
  }

  Future<AbstractToken?> getToken() async {
    return await userRepository.loadToken();
  }
}
