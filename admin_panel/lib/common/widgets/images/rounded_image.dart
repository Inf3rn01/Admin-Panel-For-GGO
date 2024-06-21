import 'package:flutter/material.dart';
import 'package:admin_panel/common/widgets/shimmers/shimmer.dart';
import '../../../utils/constants/colors.dart';

class GRoundedImage extends StatelessWidget {
  const GRoundedImage({
    super.key,
    this.width,
    this.height,
    required this.imageUrl,
    this.applyImageRadius = true,
    this.border,
    this.backgroundColor = GColors.light,
    this.fit = BoxFit.contain,
    this.padding,
    this.isNetworkImage = false,
    this.onPressed,
    this.borderRadius = 18,
  });

  final double? width, height;
  final String imageUrl;
  final bool applyImageRadius;
  final BoxBorder? border;
  final Color backgroundColor;
  final BoxFit? fit;
  final EdgeInsetsGeometry? padding;
  final bool isNetworkImage;
  final VoidCallback? onPressed;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return Container(
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          border: border,
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: const Center(
          child: Text('No data found!', style: TextStyle(color: Colors.black)),
        ),
      );
    }

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          border: border,
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: ClipRRect(
          borderRadius: applyImageRadius ? BorderRadius.circular(borderRadius) : BorderRadius.zero,
          child: Image.network(
            imageUrl,
            fit: fit,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(
                child: ShimmerEffect(width: double.infinity, height: double.infinity, radius: 13),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Center(
                child: Text('No data found!', style: TextStyle(color: Colors.black.withOpacity(0.65))),
              );
            },
          ),
        ),
      ),
    );
  }
}