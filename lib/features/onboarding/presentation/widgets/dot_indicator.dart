import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';

class DotIndicator extends StatelessWidget {
  final bool isActive;

  const DotIndicator({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      width: isActive ? 20 : 8,
      height: 8.h,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(10.r),
      ),
    );
  }
}