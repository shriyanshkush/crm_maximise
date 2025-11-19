import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  // HEADINGS → BD Megatoya
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: "BDMegatoya",
    fontSize: 26,
    color: AppColors.textPrimary,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: "BDMegatoya",
    fontSize: 20,
    color: AppColors.textPrimary,
  );

  // BODY → Gilroy
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: "Gilroy",
    fontSize: 16,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: "Gilroy",
    fontSize: 14,
    color: AppColors.textSecondary,
  );

  static const TextStyle button = TextStyle(
    fontFamily: "Gilroy",
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.textWhite,
  );
}
