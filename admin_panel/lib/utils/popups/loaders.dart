import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:admin_panel/utils/helpers/helper_functions.dart';
import 'package:icons_plus/icons_plus.dart';

import '../constants/colors.dart';

class Loaders {
  static hideSnackBar() => ScaffoldMessenger.of(Get.context!).hideCurrentSnackBar();

  static customToast({required message}) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        elevation: 0,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.transparent,
        content: Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: GHelperFunctions.isDarkMode(Get.context!) ? GColors.darkerGrey.withOpacity(0.9) : GColors.grey.withOpacity(0.9),
          ),
          child: Center(child: Text(message, style: const TextStyle(fontSize: 15, color: GColors.light))),
        ),
      ),
    );
  }

  static successSnackBar({required title, message = '', duration = 3}) {
    Get.snackbar(
      title,
      message,isDismissible: true,
      shouldIconPulse: true,
      colorText: GColors.white,
      backgroundColor: Colors.green,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: duration),
      margin: const EdgeInsets.all(10),
      icon: const Icon(HeroIcons.check, color: GColors.white)
    );
  }

  static warningSnackBar({required title, message = ''}) {
    Get.snackbar(
      title,
      message,isDismissible: true,
      shouldIconPulse: true,
      colorText: GColors.white,
      backgroundColor: Colors.orange,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(20),
      icon: const Icon(Iconsax.warning_2_outline, color: GColors.white)
    );
  }

  static errorSnackBar({required title, message = ''}) {
    Get.snackbar(
      title,
      message,isDismissible: true,
      shouldIconPulse: true,
      colorText: GColors.white,
      backgroundColor: Colors.red.shade600,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(20),
      icon: const Icon(Iconsax.warning_2_outline, color: GColors.white)
    );
  }

}
