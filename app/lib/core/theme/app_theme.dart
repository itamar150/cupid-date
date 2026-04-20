import 'package:cupid_date/core/theme/app_colors.dart';
import 'package:cupid_date/core/theme/app_radius.dart';
import 'package:cupid_date/core/theme/app_spacing.dart';
import 'package:cupid_date/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: AppColors.colorScheme,
    textTheme: AppTypography.textTheme,
    scaffoldBackgroundColor: AppColors.background,
    extensions: const [
      AppSpacing.instance,
      AppRadius.instance,
    ],
  );
}
