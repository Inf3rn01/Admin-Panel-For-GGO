import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:admin_panel/data/repositories/authentication/authentication_repository.dart';
import 'package:admin_panel/data/repositories/user/user_repository.dart';
import 'package:admin_panel/authentication/screens/login/login.dart';
import 'package:admin_panel/utils/popups/full_screen_loader.dart';
import 'package:admin_panel/utils/popups/loaders.dart';
import 'package:image_picker/image_picker.dart';
import '../../../utils/constants/images_strings.dart';
import '../../../utils/helpers/network_manager.dart';
import '../models/user_model.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  final profileLoading = false.obs;
  Rx<UserModel> user = UserModel.empty().obs; 

  final imageUploading = false.obs;
  final hidePassword = true.obs;
  final verifyEmail = TextEditingController();
  final verifyPassword = TextEditingController();
  final userRepository = Get.put(UserRepository());
  GlobalKey<FormState> reAuthFormKey = GlobalKey<FormState>();


  @override
  void onInit() {
    fetchUserRecord();
    super.onInit();
  }

  Future<void> fetchUserRecord() async {
    try {
      profileLoading.value = true;
      final user = await userRepository.fetchUserDetails();
      this.user(user);
    } catch (e) {
        user(UserModel.empty());
    } finally {
      profileLoading.value = false;
    }
  }


  /// Сохранение записи пользователя из любого поставщика регистрации
  Future<void> saveUserRecord(UserCredential? userCredential) async {
    try {
      await fetchUserRecord();
      if (user.value.id.isEmpty) {
        if (userCredential != null && userCredential.user != null){
          final user = UserModel(
            id: userCredential.user!.uid,
            name: userCredential.user!.displayName ?? '',
            phoneNumber: userCredential.user!.phoneNumber ?? '',
            email: userCredential.user!.email ?? '',
            profilePicture: userCredential.user!.photoURL ?? '',
            balance: '0',
          );
          await userRepository.saveUserRecord(user);
        }
      }
    } catch (e) {
      Loaders.warningSnackBar(title: 'Данные не были сохранены', message: 'Что-то пошло не так при сохранении вашей информации. Вы можете повторно сохранить данные в своем профиле.');
    }
  }

  Future<void> logout() async {
    try {
      // Очищаем данные пользователя
      user.value = UserModel.empty();

      // Удаляем токен аутентификации или другую информацию из хранилища
      await AuthenticationRepository.instance.logout();

      // Перенаправляем пользователя на экран входа
      Get.offAll(() => const LoginScreen());
    } catch (e) {
      Loaders.warningSnackBar(title: 'Ошибка', message: 'Не удалось выйти из аккаунта: $e');
    }
  }

  // /// Delete account warning
  // void deleteAccountWarningPopup() {
  //   Get.defaultDialog(
  //     contentPadding: const EdgeInsets.all(GSizes.md),
  //     title: 'Удалить аккаунт',
  //     middleText: 'Вы уверены, что хотите удалить свою учетную запись навсегда? Это действие не обратимо, и все ваши данные будут удалены навсегда.',
  //     confirm: ElevatedButton(
  //       onPressed: () async => deleteUserAccount(),
  //       style: ElevatedButton.styleFrom(
  //         backgroundColor: Colors.red,
  //         side: const BorderSide(color: Colors.red),
  //       ),
  //       child: const Padding(
  //         padding: EdgeInsets.symmetric(horizontal: GSizes.lg),
  //         child: Text('Удалить', style: TextStyle(fontSize: 13.2),),
  //       ),
  //     ),
  //     cancel: OutlinedButton(
  //       onPressed: () => Navigator.of(Get.overlayContext!).pop(),
  //       child: const Text('Вернуться'),
  //     ),
  //   );
  // }

  Future<void> deductBalance(double amount) async {
    final currentBalance = double.tryParse(user.value.balance) ?? 0.0;
    if (currentBalance < amount) {
      throw Exception('Недостаточно средств на балансе');
    }
    final newBalance = currentBalance - amount;

    user.update((user) {
      if (user != null) {
        user.balance = newBalance.toString();
      }
    });

    await userRepository.updateUserDetails(user.value);
  }


//   /// Удаление аккаунта пользователя 
// void deleteUserAccount() async { 
//   try { 
//     FullScreenLoader.openLoadingDialog('Обработка...', GImages.loading); 

//     final auth = AuthenticationRepository.instance; 
//     final provider = auth.authUser!.providerData.map((e) => e.providerId).first; 
//     if (provider == 'password') { 
//       FullScreenLoader.stopLoading(); 
//       Get.to(() => const ReAuthLoginForm()); 
//     }  
//   } catch (e) { 
//     FullScreenLoader.stopLoading(); 
//     Loaders.warningSnackBar(title: 'Ошибка!', message: e.toString()); 
//   } 
// }

/// Re-authenticate before deleting 
Future<void> reAuthenticateEmailAndPasswordUser() async { 
  try { 
    FullScreenLoader.openLoadingDialog('Обработка...', GImages.loading); 

    final isConnected = await NetworkManager.instance.isConnected(); 
    if (!isConnected){ 
      FullScreenLoader.stopLoading(); 
      return; 
    }  

    if (reAuthFormKey.currentState != null && !reAuthFormKey.currentState!.validate()){ 
      FullScreenLoader.stopLoading(); 
      return; 
    } 

    final userId = AuthenticationRepository.instance.authUser!.uid;
    
    await AuthenticationRepository.instance.reAuthenticateWithEmailAndPassword(verifyEmail.text.trim(), verifyPassword.text.trim()); 
    await AuthenticationRepository.instance.deleteAccount(); 

    // Удаляем корзину пользователя из базы данных
    await UserRepository.instance.deleteCart(userId);

    FullScreenLoader.stopLoading(); 
    Get.offAll(() => const LoginScreen()); 
    Loaders.successSnackBar(title: 'Аккаунт удалён', message: 'Ваша учетная запись успешно удалена.'); 
  } catch (e) { 
    FullScreenLoader.stopLoading(); 
    Loaders.warningSnackBar(title: 'Ой!', message: e.toString()); 
  } 
}


  /// Upload profile image
  uploadUserProfilePicture() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(image != null) {
        imageUploading.value = true;

        final imageUrl = await userRepository.uploadImage('Users/Images/Profile/', image);

        Map<String, dynamic> json = {'ProfilePicture': imageUrl};
        await userRepository.updateSingleField(json);

        user.value.profilePicture = imageUrl;
        user.refresh();

        Loaders.successSnackBar(title: 'Поздравляю', message: 'Изображение вашего профиля было обновлено.');
      }
    } catch (e) {
      Loaders.errorSnackBar(title: 'Ой!', message: 'Что-то пошло не так: $e');
    } finally {
      imageUploading.value = false;
    }   
  }
}
