import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/helpers/helper_functions.dart';

class SearchContainer extends StatefulWidget {
  const SearchContainer({
    super.key,
    required this.text,
    this.showBackground = true,
    this.showBorder = true,
    this.onTap,
    required this.onChanged,
  });

  final String text;
  final bool showBackground, showBorder;
  final VoidCallback? onTap;
  final ValueChanged<String> onChanged;

  @override
  _SearchContainerState createState() => _SearchContainerState();
}

class _SearchContainerState extends State<SearchContainer> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      widget.onChanged(_controller.text);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final darkTheme = GHelperFunctions.isDarkMode(context);

    return GestureDetector(
      onTap: widget.onTap,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          // Determine if the screen is small or large
          bool isLargeScreen = constraints.maxWidth > 600;

          // Adjust padding based on screen size
          EdgeInsets responsivePadding = isLargeScreen
              ? const EdgeInsets.symmetric(horizontal: 50.0, vertical: 25.0)
              : const EdgeInsets.symmetric(horizontal: 27.0, vertical: 20.0);

          // Adjust hint text style based on screen size
          TextStyle hintStyle = TextStyle(
            fontSize: isLargeScreen ? 16 : 14,
            color: GColors.darkGrey,
            fontWeight: FontWeight.w500,
          );

          return Padding(
            padding: responsivePadding,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Iconsax.search_normal_1_outline,
                        size: 18,
                        color: GColors.darkGrey,
                      ),
                      border: widget.showBorder ? const OutlineInputBorder() : InputBorder.none,
                      hintText: widget.text,
                      hintStyle: hintStyle,
                      filled: widget.showBackground,
                      fillColor: darkTheme ? GColors.dark : GColors.light,
                      contentPadding: const EdgeInsets.symmetric(vertical: 17.0),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}