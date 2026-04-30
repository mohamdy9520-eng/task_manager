import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buttonNavBar({
  required int currentIndex,
  required Function(int) onTap,
}) {
  return SizedBox(
    height: 60.h,
    child: BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,

      type: BottomNavigationBarType.fixed,

      backgroundColor: Colors.white,

      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,

      selectedIconTheme: IconThemeData(
        size: 28.sp,
        color: Colors.blue,
      ),

      unselectedIconTheme:  IconThemeData(
        size: 24.sp,
        color: Colors.grey,
      ),

      showSelectedLabels: false,
      showUnselectedLabels: false,

      elevation: 0,

      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
      ],
    ),
  );
}