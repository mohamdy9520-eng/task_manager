import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget done(String number, String title, Color color) {
  return Container(
    height: 150.h,
    width: 162.w,
    decoration: BoxDecoration(
      color: const Color(0xff00B288),
      borderRadius: BorderRadius.circular(15.r),
    ),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(number,
              style: TextStyle(
                  fontSize: 22.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
          Text(title,
              style: const TextStyle(color: Colors.white)),
        ],
      ),
    ),
  );
}

Widget inProgress(String number, String title, Color color) {
  return Container(
    height: 105.h,
    width: 161.w,
    decoration: BoxDecoration(
      color: const Color(0xffFF9E2D),
      borderRadius: BorderRadius.circular(15.r),
    ),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(number,
              style: TextStyle(
                  fontSize: 22.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
          Text(title,
              style: const TextStyle(color: Colors.white)),
        ],
      ),
    ),
  );
}

Widget onGoing(String number, String title, Color color) {
  return Container(
    height: 105.h,
    width: 162.w,
    decoration: BoxDecoration(
      color: const Color(0xffFF1B5E),
      borderRadius: BorderRadius.circular(15.r),
    ),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(number,
              style: TextStyle(
                  fontSize: 22.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
          Text(title,
              style: const TextStyle(color: Colors.white)),
        ],
      ),
    ),
  );
}

Widget waiting(String number, String title, Color color) {
  return Container(
    height: 149.h,
    width: 161.w,
    decoration: BoxDecoration(
      color: const Color(0xff29BAE2),
      borderRadius: BorderRadius.circular(15.r),
    ),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(number,
              style: TextStyle(
                  fontSize: 22.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
          Text(title,
              style: const TextStyle(color: Colors.white)),
        ],
      ),
    ),
  );
}