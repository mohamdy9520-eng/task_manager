import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget customHeader() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Monday", style: TextStyle(color: Colors.grey)),
          Text("25 October",
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
        ],
      ),
      Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey.shade200,
            child: const Icon(Icons.search),
          ),
          SizedBox(width: 10.w),

          const CircleAvatar(
            backgroundImage: NetworkImage(
                "https://i.pravatar.cc/150?img=3"),
          ),
        ],
      )
    ],
  );
}