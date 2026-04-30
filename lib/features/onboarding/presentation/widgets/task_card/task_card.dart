import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String time;
  final Color color;
  final String? status;

  const TaskCard({
    super.key,
    required this.title,
    required this.time,
    required this.color,
    this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10.w, bottom: 10.h),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (status != null)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    _getStatusLabel(status!),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
           SizedBox(height: 8.h),
          Text(
            time,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'done':
        return 'Done';
      case 'inProgress':
        return 'In Progress';
      case 'ongoing':
        return 'Ongoing';
      case 'waitingForReview':
        return 'Waiting';
      default:
        return 'In Progress';
    }
  }
}