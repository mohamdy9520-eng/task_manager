import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

class AppTextStyles {
  static TextStyle heading = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static  TextStyle title = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static  TextStyle body = TextStyle(
    fontSize: 27.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.textSecondary,
  );

  static  TextStyle small = TextStyle(
    fontSize: 12.sp,
    color: AppColors.textSecondary,
  );

  static  TextStyle primaryText = TextStyle(
    fontSize: 25.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  static TextStyle headers = TextStyle(
    fontSize: 35.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.textSecondary,
  );
}