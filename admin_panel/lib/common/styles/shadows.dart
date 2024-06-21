import 'package:flutter/material.dart';
import 'package:admin_panel/utils/constants/colors.dart';

class GShadowStyle {

  static final verticalProductShadow = BoxShadow(
    color: GColors.darkGrey.withOpacity(0.1),
    blurRadius: 50,
    spreadRadius: 7,
    offset: const Offset(0, 2)
  );

  static final horizontalProductShadow =  BoxShadow(
    color: GColors.darkGrey.withOpacity(0.1),
    blurRadius: 50,
    spreadRadius: 7,
    offset: const Offset(0, 2)
  );
}
