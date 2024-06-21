import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:admin_panel/authentication/screens/login/password_configuration/reset_password.dart';
import 'package:admin_panel/utils/constants/images_strings.dart';
import 'package:admin_panel/utils/popups/full_screen_loader.dart';

import '../../../../data/repositories/authentication/authentication_repository.dart';
import '../../../../utils/helpers/network_manager.dart';
import '../../../../utils/popups/loaders.dart';

class ForgetPasswordController extends GetxController{
  static ForgetPasswordController get instance => Get.find();

  /// Variables
  final email = TextEditingController();
  GlobalKey<FormState> forgetPasswordFormKey = GlobalKey<FormState>();

  /// Send reset password email
  sendPasswordResetEmail() async {
    try {
      
      // Start loading
      FullScreenLoader.openLoadingDialog('Обрабатываю ваши данные...', GImages.loading);

      //Check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected){
        // Remove loader
        FullScreenLoader.stopLoading();
        return;
      } 

      // Form validation
      if (forgetPasswordFormKey.currentState != null && !forgetPasswordFormKey.currentState!.validate()){
        // Remove loader
        FullScreenLoader.stopLoading();
        return;
      }

      // Send email to reset password
      await AuthenticationRepository.instance.sendPasswordResetEmail(email.text.trim());

      // Remove loader
      FullScreenLoader.stopLoading();

      // Show success screen
      Loaders.successSnackBar(title: 'Письмо отправлено', message: 'На вашу электронную почту отправлена ссылка для сброса пароля'.tr);

      // Redirect
      Get.to(() => ResetPasswordScreen(email: email.text.trim() ));

    } catch (e) {
      // Remove loader
      FullScreenLoader.stopLoading();

      // Show some generic error to the user
      Loaders.errorSnackBar(title: 'Ошибка!', message: e.toString());
    }
  }


  resendPasswordResetEmail(String email) async {
    try {

      // Start loading
      FullScreenLoader.openLoadingDialog('Обрабатываю ваши данные...', GImages.loading);

      //Check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected){
        // Remove loader
        FullScreenLoader.stopLoading();
        return;
      } 

      // Send email to reset password
      await AuthenticationRepository.instance.sendPasswordResetEmail(email);

      // Remove loader
      FullScreenLoader.stopLoading();

      // Show success screen
      Loaders.successSnackBar(title: 'Письмо отправлено', message: 'На вашу электронную почту отправлена ссылка для сброса пароля'.tr);

    } catch (e) {
      // Remove loader
      FullScreenLoader.stopLoading();

      // Show some generic error to the user
      Loaders.errorSnackBar(title: 'Ошибка!', message: e.toString());
    }
  }

}
