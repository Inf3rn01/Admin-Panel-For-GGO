import 'package:flutter/material.dart';
import 'package:admin_panel/common/widgets/shimmers/shimmer.dart';
import 'package:admin_panel/utils/constants/sizes.dart';


class CategoryShimmer extends StatelessWidget {
  const CategoryShimmer({
    super.key,
    this.itemCount = 6,
    });

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: itemCount,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (_, __) => const SizedBox(width: GSizes.spaceBtwItems),
        itemBuilder: (_, __) {
          return const Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              SizedBox(height: 5),

              ///Image
              ShimmerEffect(width: 58, height: 58, radius: 58),
              
              SizedBox(height: 5),

              /// Text
              ShimmerEffect(width: 51, height: 9)

            ],
          );
        },
      ),
    );
  }
}