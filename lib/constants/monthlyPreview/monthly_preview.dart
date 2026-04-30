import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../app_colors/text_style.dart';

Widget monthlyPreview() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Monthly Preview",
        style: AppTextStyles.body,
      ),

      SizedBox(height: 20.h),

      Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Container(
                  height: 160.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xffA9FFEA), Color(0xff00B288)],
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("22", style: AppTextStyles.title.copyWith(
                            fontSize: 32.sp,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          "Done",
                          style: AppTextStyles.title.copyWith(
                            fontSize: 19.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 12.h),

                Container(
                  height: 160.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xffFFA0BC), Color(0xffFF1B5E)],
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("12", style: AppTextStyles.title.copyWith(
                            fontSize: 32.sp,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text("Ongoing", style: AppTextStyles.title.copyWith(
                            fontSize: 19.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 12.w),

          Expanded(
            child: Column(
              children: [
                Container(
                  height: 160.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xffFFD29D), Color(0xffFF9E2D)],
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "7",
                          style: AppTextStyles.title.copyWith(
                            fontSize: 32.sp,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          "In Progress",
                          style: AppTextStyles.title.copyWith(
                            fontSize: 19.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 12.h),

                Container(
                  height: 160.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xffB4E7FF), Color(0xff4CC9F0)],
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "14",
                          style: AppTextStyles.title.copyWith(
                            fontSize: 32.sp,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          "Waiting For Review",
                          style: AppTextStyles.title.copyWith(
                            fontSize: 19.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ],
  );
}