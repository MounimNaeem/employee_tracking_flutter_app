

import 'package:employee_location_tracking_app/utils/theme/font_styles/light_font_style/light_font_style.dart';
import 'package:employee_location_tracking_app/utils/theme/light_base_theme.dart';
import 'package:flutter/material.dart';

class LightTheme {
  ThemeData get theme => ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    primaryColor: primaryColor,
    hintColor: tertiaryColor,
    indicatorColor: iconColor,
    cardColor: cardColor,

      colorScheme: ColorScheme.fromSwatch().copyWith(secondary: secondaryColor,error: redColor),
    scaffoldBackgroundColor: scaffoldColor,
    buttonTheme: const ButtonThemeData(buttonColor: primaryColor),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: scaffoldColor,
        textStyle: buttonText,
      ),
    ),
  );
}