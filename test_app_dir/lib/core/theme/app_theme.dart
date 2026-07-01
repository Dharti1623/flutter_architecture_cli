import 'package:flutter/material.dart';
import 'package:test_app_dir/core/theme/app_colors.dart';
import 'package:test_app_dir/core/theme/app_text_styles.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        error: AppColors.error,
      ),
      textTheme: const TextTheme(
        headlineLarge: AppTextStyles.h1,
        bodyLarge: AppTextStyles.body,
        bodySmall: AppTextStyles.caption,
      ),
    );
  }
}
