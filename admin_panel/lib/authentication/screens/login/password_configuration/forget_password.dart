import 'package:admin_panel/authentication/controlers/forget_password/forget_password_controller.dart';
import 'package:admin_panel/utils/constants/colors.dart';
import 'package:admin_panel/utils/constants/sizes.dart';
import 'package:admin_panel/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:admin_panel/utils/validators/validation.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../../../../utils/helpers/helper_functions.dart';

class ForgetPasswordScreen extends StatelessWidget {
  ForgetPasswordScreen({super.key});

  final controller = Get.put(ForgetPasswordController());

  @override
  Widget build(BuildContext context) {
    final darkTheme = GHelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(FontAwesome.arrow_left_solid, color: darkTheme ? GColors.white : GColors.dark, size: 22),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double horizontalPadding = constraints.maxWidth < 600 ? 16 : GSizes.defaultSpace;
            double titleFontSize = constraints.maxWidth < 600 ? 23 : 25;
            double subTitleFontSize = constraints.maxWidth < 600 ? 13 : 13;
            double spacingBetweenItems = constraints.maxWidth < 600 ? 16 : GSizes.spaceBtwItems / 1.5;
            double formSpacing = constraints.maxWidth < 600 ? 20 : GSizes.spaceBtwSections;

            return Padding(
              padding: EdgeInsets.all(horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Headings
                  Text(
                    GTexts.forgetPasswordTitle,
                    style: TextStyle(fontSize: titleFontSize, fontWeight: FontWeight.w500, color: darkTheme ? GColors.white : GColors.dark),
                  ),
                  SizedBox(height: spacingBetweenItems),
                  Text(
                    GTexts.forgetPasswordSubTitle,
                    style: TextStyle(fontSize: subTitleFontSize, color: GColors.darkGrey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 22),

                  // Text Field
                  Form(
                    key: controller.forgetPasswordFormKey,
                    child: TextFormField(
                      controller: controller.email,
                      validator: GValidator.validateEmail,
                      decoration: const InputDecoration(labelText: GTexts.email, prefixIcon: Icon(EvaIcons.email_outline)),
                    ),
                  ),
                  SizedBox(height: formSpacing),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => controller.sendPasswordResetEmail(),
                      child: const Text(GTexts.submit),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
