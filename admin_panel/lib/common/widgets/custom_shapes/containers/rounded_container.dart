import 'package:flutter/material.dart';
import 'package:admin_panel/utils/constants/colors.dart';


class GRoundedContainer extends StatelessWidget {
  const GRoundedContainer({
    super.key,
    this.child,
    this.width,
    this.height,
    this.margin,
    this.padding,
    this.showBorder = false,
    this.radius = 18.5,
    this.backgroundColor = GColors.white,
    this.borderColor = GColors.borderPrimary
  });

  final double? width;
  final double? height;
  final double radius;
  final EdgeInsetsGeometry? padding;
  final Widget? child;
  final bool showBorder;
  final Color backgroundColor;
  final EdgeInsetsGeometry? margin;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius),
        border: showBorder ? Border.all(color: borderColor) : null,
      ),
    child: child,
    );
  }
}