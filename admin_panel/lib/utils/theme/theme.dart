import 'package:flutter/material.dart';
import 'package:admin_panel/utils/theme/custom_themes/appbar_theme.dart';
import 'package:admin_panel/utils/theme/custom_themes/bottom_sheet_theme.dart';
import 'package:admin_panel/utils/theme/custom_themes/checkbox_theme.dart';
import 'package:admin_panel/utils/theme/custom_themes/chip_theme.dart';
import 'package:admin_panel/utils/theme/custom_themes/elevated_button_theme.dart';
import 'package:admin_panel/utils/theme/custom_themes/outlined_button_theme.dart';
import 'package:admin_panel/utils/theme/custom_themes/text_field_theme.dart';
import 'package:admin_panel/utils/theme/custom_themes/text_theme.dart';


class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Manrope',
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    textTheme: GTextTheme.lightTextTheme,
    chipTheme: GChipTheme.lightChipTheme,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: GAppBarTheme.lightAppBarTheme,
    checkboxTheme: GCheckBoxTheme.lightCheckBoxTheme,
    bottomSheetTheme: GBottomSheetTheme.lightBottomSheetTheme,
    elevatedButtonTheme: GElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: GOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: GTextFormFieldTheme.lightInputDecorationTheme,
    
  );
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Manrope',
    brightness: Brightness.dark,
    primaryColor: Colors.blue,
    textTheme: GTextTheme.darkTextTheme,
    chipTheme: GChipTheme.darkChipTheme,
    scaffoldBackgroundColor: const Color(0xFF101010),
    appBarTheme: GAppBarTheme.darkAppBarTheme,
    checkboxTheme: GCheckBoxTheme.darkCheckBoxTheme,
    bottomSheetTheme: GBottomSheetTheme.darkBottomSheetTheme,
    elevatedButtonTheme: GElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: GOutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: GTextFormFieldTheme.darkInputDecorationTheme,
  );
}
