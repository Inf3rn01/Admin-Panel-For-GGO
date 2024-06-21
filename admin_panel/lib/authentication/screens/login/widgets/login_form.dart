import 'package:admin_panel/authentication/controlers/login/login_controller.dart';
import 'package:admin_panel/authentication/screens/login/password_configuration/forget_password.dart';
import 'package:admin_panel/utils/constants/sizes.dart';
import 'package:admin_panel/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:admin_panel/utils/validators/validation.dart';
import 'package:icons_plus/icons_plus.dart';

class GLoginForm extends StatelessWidget {
  const GLoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    
    return LayoutBuilder(
      builder: (context, constraints) {
        double verticalPadding = constraints.maxWidth < 600 ? 16 : GSizes.spaceBtwSections;
        double inputFieldSpacing = constraints.maxWidth < 600 ? 12 : GSizes.spaceBtwInputFields;
        double rememberMeFontSize = constraints.maxWidth < 600 ? 14.5 : 14.5;
        double forgetPasswordFontSize = constraints.maxWidth < 600 ? 14.5 : 14.3;
        return Form(
          key: controller.loginFormKey,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: verticalPadding),
            child: Column(
              children: [
                // Email
                TextFormField(
                  controller: controller.email,
                  validator: (value) => GValidator.validateEmail(value),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(EvaIcons.email_outline),
                    labelText: GTexts.email,
                  ),
                ),
                SizedBox(height: inputFieldSpacing),
                
                // Password
                Obx(
                  () => TextFormField(
                    controller: controller.password,
                    obscureText: controller.hidePassword.value,
                    validator: (value) => GValidator.validateEmptyText('пароль', value),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Iconsax.password_check_outline),
                      labelText: GTexts.password,
                      suffixIcon: IconButton(
                        onPressed: () => controller.hidePassword.value = !controller.hidePassword.value,
                        icon: Icon(controller.hidePassword.value ? Iconsax.eye_slash_outline : Iconsax.eye_outline),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                
                // Remember Me & Forget Password
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Remember Me
                    Row(
                      children: [
                        SizedBox(
                          height: 20,
                          width: 25, 
                          child: Obx(
                            () => Checkbox(
                              value: controller.rememberMe.value,
                              onChanged: (value) {controller.rememberMe.value = value!;},
                            ),
                          ),
                        ),
                        Text(
                          GTexts.rememberMe,
                          style: TextStyle(fontWeight: FontWeight.w400, fontSize: rememberMeFontSize),
                        ),
                      ],
                    ),

                    // Forget Password
                    TextButton(
                      onPressed: () => Get.to(() => ForgetPasswordScreen()),
                      child: Text(
                        'Забыли пароль?',
                        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600, fontSize: forgetPasswordFontSize),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                
                // Sign In Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => controller.signIn(),
                    child: const Text(GTexts.signIn),
                  ),
                ), 
              ],
            ),
          ),
        );
      },
    );
  }
}
