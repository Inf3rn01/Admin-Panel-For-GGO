import 'package:admin_panel/utils/constants/sizes.dart';
import 'package:flutter/widgets.dart';

class GSpacingStyle {
  static const EdgeInsetsGeometry paddingWithAppBarHeigth = EdgeInsets.only(
    top: GSizes.appBarHeight,
    left: GSizes.defaultSpace,
    bottom: GSizes.defaultSpace,
    right: GSizes.defaultSpace,
  );
}