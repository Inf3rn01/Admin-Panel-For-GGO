import 'package:flutter/material.dart';
import 'package:admin_panel/utils/helpers/helper_functions.dart';
import 'package:shimmer/shimmer.dart';

import '../../../utils/constants/colors.dart';

class ShimmerEffect extends StatelessWidget {
  const ShimmerEffect({
    super.key,
    required this.width,
    required this.height,
    this.radius = 15,
    this.color,
    });

  final double width, height, radius;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final darkTheme = GHelperFunctions.isDarkMode(context);
    return Shimmer.fromColors(
      baseColor: darkTheme ? Colors.grey[850]! : Colors.grey[300]!,
      highlightColor: darkTheme ? Colors.grey[800]! : Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color ?? (darkTheme ? GColors.darkerGrey : GColors.white),
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}