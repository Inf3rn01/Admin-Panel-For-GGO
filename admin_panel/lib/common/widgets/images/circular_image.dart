import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:admin_panel/common/widgets/shimmers/shimmer.dart';
import 'package:admin_panel/utils/constants/colors.dart';
import 'package:admin_panel/utils/helpers/helper_functions.dart';



class GCircularImage extends StatelessWidget {
  const GCircularImage({
    super.key,
    this.width = 58,
    this.height = 58,
    this.overlayColor,
    this.backgroundColor,
    required this.image,
    this.fit = BoxFit.cover,
    this.padding = 5.5,
    this.isNetworkImage = false,
    });

  final BoxFit? fit;
  final String image;
  final bool isNetworkImage;
  final Color? overlayColor;
  final Color? backgroundColor;
  final double width, height, padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: backgroundColor ?? (GHelperFunctions.isDarkMode(context) ? GColors.black : GColors.white),
        borderRadius: BorderRadius.circular(100),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Center(
          child: isNetworkImage
              ? CachedNetworkImage(
                  fit: fit,
                  color: overlayColor,
                  imageUrl: image,
                  progressIndicatorBuilder: (context, url, downloadProgress) => const ShimmerEffect(width: 55, height: 55),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                )
              : Image(
                  fit: fit,
                  image: AssetImage(image),
                  color: overlayColor,
                ),
        ),
      ),
    );
  }
}