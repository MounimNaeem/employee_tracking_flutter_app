
import 'package:employee_location_tracking_app/utils/enums/enums.dart';
import 'package:employee_location_tracking_app/utils/theme/available_themes/light_theme.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData getTheme({AllThemes theme = AllThemes.light}) {
    switch (theme) {
      case AllThemes.light:
        return LightTheme().theme;
      default:
        return LightTheme().theme;
    }
  }
}
