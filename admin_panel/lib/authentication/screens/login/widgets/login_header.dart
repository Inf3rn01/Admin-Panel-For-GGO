import 'package:admin_panel/utils/constants/images_strings.dart';
import 'package:admin_panel/utils/constants/sizes.dart';
import 'package:admin_panel/utils/constants/text_strings.dart';
import 'package:admin_panel/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';


class GLoginHeader extends StatelessWidget {
  const GLoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = GHelperFunctions.isDarkMode(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        double imageHeight = constraints.maxWidth < 600 ? 100 : 140;
        double titleFontSize = constraints.maxWidth < 600 ? 24 : 32;
        double subTitleFontSize = constraints.maxWidth < 600 ? 14 : 18;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              height: imageHeight,
              image: AssetImage(dark ? GImages.lightAppLogo : GImages.darkAppLogo),
            ),
            const SizedBox(height: GSizes.sm),
            Text(
              GTexts.loginTitle,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: titleFontSize),
            ),
            const SizedBox(height: GSizes.sm),
            Text(
              GTexts.loginSubTitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: subTitleFontSize),
            ),
          ],
        );
      },
    );
  }
}
