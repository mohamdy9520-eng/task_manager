import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:task_manager_app/core/services/firestore_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final firestore = FirestoreService();

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _homeContent(),
    );
  }

  Widget _homeContent() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDynamicHeader(),
              SizedBox(height: 20.h),
              _buildDynamicGreeting(),
              SizedBox(height: 20.h),
              _buildDynamicMainCard(),
              SizedBox(height: 20.h),
              _buildDynamicMonthlyPreview(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDynamicHeader() {
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
                Text(dayName, style: const TextStyle(color: Colors.grey)),
                Text(
                  "$dayNumber $monthName",
                  style:  TextStyle(
                      fontSize: 24.sp, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.search, color: Colors.grey),
                SizedBox(width: 10.w),
                _buildProfileAvatar(photoUrl),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildProfileAvatar(String? photoUrl) {
    if (photoUrl != null && photoUrl.isNotEmpty) {
      return CircleAvatar(
        radius: 20.r,
        backgroundImage: NetworkImage(photoUrl),
      );
    }
    return CircleAvatar(
      radius: 20.r,
      child: Icon(Icons.person),
    );
  }

  Widget _buildDynamicGreeting() {
    return StreamBuilder<DocumentSnapshot>(
      stream: firestore.getUserProfile(),
      builder: (context, userSnapshot) {
        String name = "User";

        if (userSnapshot.hasData && userSnapshot.data!.exists) {
          final data = userSnapshot.data!.data() as Map<String, dynamic>;
          name = data['name'] ?? "User";
        }

        return StreamBuilder<int>(
          stream: firestore.getPendingTasksCount(),
          builder: (context, tasksSnapshot) {
            final count = tasksSnapshot.data ?? 0;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hi $name.",
                  style: TextStyle(
                      fontSize: 28.sp, fontWeight: FontWeight.bold),
                ),
                Text("$count Tasks are pending",
                    style: const TextStyle(color: Colors.grey)),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildDynamicMainCard() {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore.getTasks(),
      builder: (context, snapshot) {
        String title = "No Tasks";
        String subtitle = "";
        String statusText = "Now";

        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          final data =
          snapshot.data!.docs.first.data() as Map<String, dynamic>;

          title = data['title'] ?? "";
          subtitle =
          "${data['startTime'] ?? ''} - ${data['endTime'] ?? ''}";

          final status = data['status'] ?? 'inProgress';
          statusText = status == 'done'
              ? "Done"
              : status == 'ongoing'
              ? "Ongoing"
              : status == 'waitingForReview'
              ? "Waiting"
              : "In Progress";
        }

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            gradient: const LinearGradient(
              colors: [Color(0xFF6D5DF6), Color(0xFF46A0F0)],
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                    Text(subtitle,
                        style: const TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
              Text(statusText,
                  style: const TextStyle(color: Colors.white)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDynamicMonthlyPreview() {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore.getTasks(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        int done = 0, progress = 0, ongoing = 0, waiting = 0;

        for (var task in snapshot.data!.docs) {
          final status =
              (task.data() as Map<String, dynamic>)['status'] ?? 'inProgress';

          if (status == 'done') done++;
          if (status == 'inProgress') progress++;
          if (status == 'ongoing') ongoing++;
          if (status == 'waitingForReview') waiting++;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text("Monthly Preview",
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 16.h),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12.h,
              crossAxisSpacing: 12.w,
              childAspectRatio: 1.1,
              children: [
                _box(done, "Done", Colors.green),
                _box(progress, "In Progress", Colors.orange),
                _box(ongoing, "Ongoing", Colors.pink),
                _box(waiting, "Waiting", Colors.blue),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _box(int count, String label, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("$count",
                style:  TextStyle(
                    fontSize: 30.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
             SizedBox(height: 5.h),
            Text(label, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}