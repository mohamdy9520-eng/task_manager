import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_manager_app/core/services/firestore_service.dart';

Widget customGreeting() {
  final firestore = FirestoreService();

  return StreamBuilder<DocumentSnapshot>(
    stream: firestore.getUserProfile(),
    builder: (context, userSnapshot) {
      String userName = "User";

      if (userSnapshot.hasData && userSnapshot.data!.exists) {
        final data = userSnapshot.data!.data() as Map<String, dynamic>;
        userName = data['name'] ?? "User";
      }

      return StreamBuilder<int>(
        stream: firestore.getPendingTasksCount(),
        builder: (context, tasksSnapshot) {
          int pendingCount = tasksSnapshot.data ?? 0;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hi $userName.",
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                "$pendingCount Tasks are pending",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey,
                ),
              ),
            ],
          );
        },
      );
    },
  );
}