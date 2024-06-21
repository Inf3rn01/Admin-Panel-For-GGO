import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:admin_panel/utils/helpers/helper_functions.dart';

import '../../common/widgets/loaders/animation_loader.dart';
import '../constants/colors.dart';

class FullScreenLoader {
  static void openLoadingDialog(String text, String animation) {
    showDialog(
      context: Get.overlayContext!,
      barrierDismissible: false,
      builder: (_) => WillPopScope(
        onWillPop: () async => false,
        child: Container(
          color: GHelperFunctions.isDarkMode(Get.context!) ? GColors.dark : GColors.white,
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: AnimationLoaderWidget(text: text, animation: animation),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void stopLoading() {
    Navigator.of(Get.overlayContext!).pop();
  }
}