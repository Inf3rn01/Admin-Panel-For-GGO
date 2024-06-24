import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:admin_panel/data/repositories/authentication/authentication_repository.dart';
import 'package:admin_panel/utils/constants/images_strings.dart';
import 'package:admin_panel/utils/helpers/network_manager.dart';
import 'package:admin_panel/utils/popups/full_screen_loader.dart';
import 'package:admin_panel/utils/popups/loaders.dart';

class LoginController extends GetxController {
  /// Variables
  final rememberMe = false.obs;
  final hidePassword = true.obs;
  final localStorage = GetStorage();
  final email = TextEditingController();
  final password = TextEditingController();
  final loginFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    String? savedEmail = localStorage.read('REMEMBER_ME_EMAIL');
    String? savedPassword = localStorage.read('REMEMBER_ME_PASSWORD');
    if (savedEmail != null && savedPassword != null) {
      email.text = savedEmail;
      password.text = savedPassword;
      rememberMe.value = true;
    }
  }

 /// SignIn
  void signIn() async {
    try {
      //FullScreenLoader.openLoadingDialog('Вход в систему...', GImages.loading);

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        //FullScreenLoader.stopLoading();
        Loaders.errorSnackBar(
            title: 'Нет интернета', 
            message: 'Пожалуйста, проверьте подключение к Интернету и повторите попытку'
        );
        return;
      }

      if (loginFormKey.currentState != null && !loginFormKey.currentState!.validate()) {
        //FullScreenLoader.stopLoading();
        return;
      }

      if (rememberMe.value) {
        localStorage.write('REMEMBER_ME_EMAIL', email.text.trim());
        localStorage.write('REMEMBER_ME_PASSWORD', password.text.trim());
      } else {
        localStorage.remove('REMEMBER_ME_EMAIL');
        localStorage.remove('REMEMBER_ME_PASSWORD');
      }

      final userCredential = await AuthenticationRepository.instance.loginWithEmailAndPassword(
          email.text.trim(), password.text.trim()
      );

      if (userCredential.user != null && !userCredential.user!.emailVerified) {
        //FullScreenLoader.stopLoading();
        Loaders.warningSnackBar(
          title: 'Email не подтвержден',
          message: 'Пожалуйста, подтвердите ваш email для продолжения'
        );
        return;
      }

      AuthenticationRepository.instance.screenRedirect();
      
      //FullScreenLoader.stopLoading();

    } catch (e) {
      //FullScreenLoader.stopLoading();
      Loaders.errorSnackBar(title: 'Ошибка!', message: 'Не верный логин или пароль');
    }
  }

}