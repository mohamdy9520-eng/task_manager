import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
              // ✅ الاسم الديناميكي
              Text(
                "Hi $userName.",
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              // ✅ عدد التاسكات الديناميكي
              Text(
                "$pendingCount Tasks are pending",
                style: const TextStyle(
                  fontSize: 14,
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