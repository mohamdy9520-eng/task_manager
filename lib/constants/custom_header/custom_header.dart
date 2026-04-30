import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:task_manager_app/core/services/firestore_service.dart';

Widget customHeader() {
  final firestore = FirestoreService();
  final now = DateTime.now();

  final dayName = DateFormat('EEEE').format(now);
  final dayNumber = DateFormat('d').format(now);
  final monthName = DateFormat('MMMM').format(now);

  return StreamBuilder<DocumentSnapshot>(
    stream: firestore.getUserProfile(),
    builder: (context, snapshot) {
      String? photoUrl;

      if (snapshot.hasData && snapshot.data!.exists) {
        final data = snapshot.data!.data() as Map<String, dynamic>;
        photoUrl = data['photoUrl'];
      }

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dayName,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey,
                ),
              ),
              Text(
                "$dayNumber $monthName",
                style:  TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.search, color: Colors.grey),
              ),
              SizedBox(width: 10.w),
              GestureDetector(
                onTap: () {

                },
                child: CircleAvatar(
                  radius: 20.r,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage: photoUrl != null && photoUrl.isNotEmpty
                      ? NetworkImage(photoUrl)
                      : null,
                  onBackgroundImageError: (_, __) {},
                  child: photoUrl == null || photoUrl.isEmpty
                      ? const Icon(Icons.person, color: Colors.grey)
                      : null,
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}