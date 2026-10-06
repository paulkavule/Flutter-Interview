import 'package:flutter/material.dart';

abstract final class AppColors {
  static const ink = Color(0xFF0A0A0A);
  static const paper = Color(0xFFFFFFFF);
  static const brand = Color(0xFF1F4FFF);
  static const success = Color.fromARGB(255, 29, 123, 70);
  static const danger = Color(0xFFE5322D);
  static const muted = Color(0x8A0A0A0A);
  static const hairline = Color(0x1F0A0A0A);
}

/// Minimal light theme: hairline outlines and generous radii, no decoration.
ThemeData buildAppTheme() {
  const radius = BorderRadius.all(Radius.circular(14));
  OutlineInputBorder border(Color color, [double width = 1]) =>
      OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: color, width: width),
      );

  return ThemeData(
    colorScheme: const ColorScheme.light(
      primary: AppColors.brand,
      secondary: AppColors.ink,
      error: AppColors.danger,
      onSurface: AppColors.ink,
    ),
    scaffoldBackgroundColor: AppColors.paper,
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(18),
      labelStyle: const TextStyle(color: AppColors.muted),
      floatingLabelStyle: const TextStyle(color: AppColors.brand),
      enabledBorder: border(AppColors.hairline),
      focusedBorder: border(AppColors.brand, 1.5),
      errorBorder: border(AppColors.danger),
      focusedErrorBorder: border(AppColors.danger, 1.5),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.brand,
        disabledBackgroundColor: AppColors.brand.withValues(alpha: 0.45),
        disabledForegroundColor: AppColors.paper,
        minimumSize: const Size.fromHeight(58),
        shape: const RoundedRectangleBorder(borderRadius: radius),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
  );
}
