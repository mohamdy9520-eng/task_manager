import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:task_manager_app/core/services/firestore_service.dart';

Widget customHeader() {
  final firestore = FirestoreService();
  final now = DateTime.now();

  // ✅ التاريخ الديناميكي
  final dayName = DateFormat('EEEE').format(now); // Monday
  final dayNumber = DateFormat('d').format(now); // 29
  final monthName = DateFormat('MMMM').format(now); // April

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
              // ✅ اليوم الديناميكي
              Text(
                dayName,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              // ✅ التاريخ الديناميكي
              Text(
                "$dayNumber $monthName",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            children: [
              // ✅ زرار البحث
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.search, color: Colors.grey),
              ),
              const SizedBox(width: 10),
              // ✅ صورة البروفايل الديناميكية
              GestureDetector(
                onTap: () {
                  // هنروح للبروفايل لما ندوس على الصورة
                  // ممكن تضيف Navigation هنا لو عايز
                },
                child: CircleAvatar(
                  radius: 20,
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