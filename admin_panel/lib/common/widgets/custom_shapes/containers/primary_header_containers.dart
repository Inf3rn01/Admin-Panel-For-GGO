import 'package:admin_panel/common/widgets/custom_shapes/containers/circular_container.dart';
import 'package:admin_panel/common/widgets/custom_shapes/curved_edges/curved_edges_widget.dart';
import 'package:admin_panel/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:admin_panel/utils/helpers/helper_functions.dart';

class GPrimaryHeaderContainer extends StatelessWidget {
  const GPrimaryHeaderContainer({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final darkTheme = GHelperFunctions.isDarkMode(context);

    return GCurvedEdgeWidget(
      child: Container(
        color: darkTheme ? GColors.primary : GColors.softGrey,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            // Determine if the screen is small or large
            bool isLargeScreen = constraints.maxWidth > 600;

            // Adjust position and size of custom shapes based on screen size
            double topPosition1 = isLargeScreen ? -200 : -150;
            double rightPosition1 = isLargeScreen ? -300 : -250;
            double topPosition2 = isLargeScreen ? 50 : 100;
            double rightPosition2 = isLargeScreen ? -350 : -300;

            return Stack(
              children: [
                /// Background Custom Shapes
                Positioned(
                  top: topPosition1,
                  right: rightPosition1,
                  child: GCircularContainer(
                    backgroundColor: darkTheme
                        ? GColors.black.withOpacity(0.115)
                        : GColors.black.withOpacity(0.1),
                  ),
                ),
                Positioned(
                  top: topPosition2,
                  right: rightPosition2,
                  child: GCircularContainer(
                    backgroundColor: darkTheme
                        ? GColors.black.withOpacity(0.115)
                        : GColors.black.withOpacity(0.1),
                  ),
                ),
                child,
              ],
            );
          },
        ),
      ),
    );
  }
}