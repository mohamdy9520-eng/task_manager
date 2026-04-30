import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_manager_app/constants/app_colors/text_style.dart';
import 'package:task_manager_app/core/services/firestore_service.dart';

Widget mainCard() {
  final firestore = FirestoreService();

  return StreamBuilder<QuerySnapshot>(
    stream: firestore.getTasks(),
    builder: (context, snapshot) {
      String title = "No Tasks";
      String subtitle = "Add a new task";
      String timeText = "Now";

      if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
        // ✅ جلب أقرب تاسك (أول واحد في القائمة)
        final tasks = snapshot.data!.docs;
        final now = DateTime.now();

        // فلترة التاسكات اللي لسه مجتش وقتها
        final upcomingTasks = tasks.where((task) {
          final data = task.data() as Map<String, dynamic>;
          final date = DateTime.parse(data['date']);
          final startTime = data['startTime'] as String;

          // تحويل الوقت لـ DateTime
          final timeParts = startTime.split(':');
          final hour = int.parse(timeParts[0]);
          final minute = int.parse(timeParts[1].split(' ')[0]);
          final isPM = startTime.contains('PM');

          final taskDateTime = DateTime(
            date.year, date.month, date.day,
            isPM && hour != 12 ? hour + 12 : hour,
            minute,
          );

          return taskDateTime.isAfter(now);
        }).toList();

        if (upcomingTasks.isNotEmpty) {
          final nextTask = upcomingTasks.first;
          final data = nextTask.data() as Map<String, dynamic>;
          title = data['title'] ?? "Task";
          subtitle = data['startTime'] ?? "";
          timeText = "Upcoming";
        } else {
          // لو مفيش تاسكات جاية، نعرض آخر تاسك
          final lastTask = tasks.first;
          final data = lastTask.data() as Map<String, dynamic>;
          title = data['title'] ?? "Task";
          subtitle = data['startTime'] ?? "";
          timeText = "Last";
        }
      }

      return Container(
        width: 343.w,
        height: 83.h,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFF6D5DF6), Color(0xFF46A0F0)],
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      subtitle,
                      style: const TextStyle(color: Colors.white70),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Text(
              timeText,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      );
    },
  );
}