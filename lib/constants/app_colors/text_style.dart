import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const TextStyle heading = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle title = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontSize: 27,
    fontWeight: FontWeight.bold,
    color: AppColors.textSecondary,
  );

  static const TextStyle small = TextStyle(
    fontSize: 12,
    color: AppColors.textSecondary,
  );

  static const TextStyle primaryText = TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  static const TextStyle headers = TextStyle(
    fontSize: 35,
    fontWeight: FontWeight.bold,
    color: AppColors.textSecondary,
  );
}