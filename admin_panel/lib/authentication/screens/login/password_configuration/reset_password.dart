import 'package:admin_panel/authentication/controlers/forget_password/forget_password_controller.dart';
import 'package:admin_panel/authentication/screens/login/login.dart';
import 'package:admin_panel/utils/constants/sizes.dart';
import 'package:admin_panel/utils/constants/text_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    final darkTheme = GHelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(CupertinoIcons.clear),
            color: darkTheme ? GColors.white : GColors.dark)
          ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(GSizes.defaultSpace),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            // Determine if the screen is small or large
            bool isLargeScreen = constraints.maxWidth > 600;
            
            return Column(
              children: [
                // Title & SubTitle
                Text(
                  GTexts.changeYourPasswordTitle, 
                  style: Theme.of(context).textTheme.headlineMedium, 
                  textAlign: TextAlign.center
                ),
                const SizedBox(height: GSizes.spaceBtwItems),
                const Text(
                  GTexts.changeYourPasswordSubTitle, 
                  style: TextStyle(fontSize: 13, color: GColors.darkGrey), 
                  textAlign: TextAlign.center
                ),
                const SizedBox(height: 27),
                
                // Buttons with responsive width
                SizedBox(
                  width: isLargeScreen ? 400 : double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Get.offAll(() => const LoginScreen()), 
                    child: const Text('Готово')
                  ),
                ),
              
                const SizedBox(height: 12), // Adjust spacing between buttons
                
                SizedBox(
                  width: isLargeScreen ? 400 : double.infinity,
                  child: TextButton(
                    onPressed: () => ForgetPasswordController.instance.resendPasswordResetEmail(email), 
                    child: const Text(
                      GTexts.resendEmail, 
                      style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500, fontSize: 14.5)
                    )
                  )
                ),
              ],
            );
          }
        )
      ),
    );
  }
}