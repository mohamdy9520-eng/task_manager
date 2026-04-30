import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../core/services/firestore_service.dart';
import '../../../onboarding/presentation/widgets/task_card/task_card.dart';
import '../add_task_screen/add_task_screen.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime focusedDay = DateTime.now();
  DateTime selectedDay = DateTime.now();
  Set<String> daysWithTasks = {};
  final firestore = FirestoreService();

  final List<String> monthNames = [
    "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December"
  ];

  DateTime _onlyDate(DateTime d) {
    return DateTime(d.year, d.month, d.day);
  }

  @override
  Widget build(BuildContext context) {
    final today = _onlyDate(DateTime.now());

    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),
      floatingActionButton: FloatingActionButton(
        onPressed: _onlyDate(selectedDay).isBefore(today)
            ? null
            : () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddTaskScreen(date: selectedDay),
            ),
          );
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildDaySelector(),
            SizedBox(height: 10.h),
            Expanded(child: _buildTasks()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${monthNames[selectedDay.month - 1]} ${selectedDay.year}",
            style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
          ),
          StreamBuilder<DocumentSnapshot>(
            stream: firestore.getUserProfile(),
            builder: (context, snapshot) {
              String? photoUrl;

              if (snapshot.hasData && snapshot.data!.exists) {
                final data = snapshot.data!.data() as Map<String, dynamic>;
                photoUrl = data['photoUrl'];
              }

              if (photoUrl != null && photoUrl.isNotEmpty) {
                return CircleAvatar(
                  radius: 20.r,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage: NetworkImage(photoUrl),
                  onBackgroundImageError: (_, __) {},
                );
              } else {
                return CircleAvatar(
                  radius: 20.r,
                  backgroundColor: Colors.grey.shade300,
                  child: const Icon(Icons.person, color: Colors.grey),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDaySelector() {
    final today = _onlyDate(DateTime.now());
    final days = List.generate(7, (index) {
      return selectedDay.add(Duration(days: index - 3));
    });

    return SizedBox(
      height: 90.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        itemBuilder: (context, index) {
          final day = days[index];
          final isSelected = isSameDay(day, selectedDay);
          final hasTasks = daysWithTasks.contains(
            "${day.year}-${day.month}-${day.day}",
          );
          final isPast = _onlyDate(day).isBefore(today);

          return GestureDetector(
            onTap: isPast
                ? null
                : () {
              setState(() => selectedDay = day);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(horizontal: 8.w),
              width: 70.w,
              decoration: BoxDecoration(
                color: isPast
                    ? Colors.grey.shade300
                    : (isSelected ? Colors.deepPurple : Colors.white),
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  if (isSelected && !isPast)
                    BoxShadow(
                      color: Colors.deepPurple.withOpacity(0.4),
                      blurRadius: 10.r,
                    )
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${day.day}",
                    style: TextStyle(
                      fontSize: 22.sp,
                      color: isPast
                          ? Colors.grey
                          : (isSelected ? Colors.white : Colors.black),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _weekDay(day),
                    style: TextStyle(
                      color: isPast
                          ? Colors.grey
                          : (isSelected ? Colors.white70 : Colors.grey),
                    ),
                  ),
                  if (hasTasks)
                    Container(
                      margin: EdgeInsets.only(top: 5.h),
                      width: 6.w,
                      height: 6.h,
                      decoration: BoxDecoration(
                        color: isPast
                            ? Colors.grey
                            : (isSelected ? Colors.white : Colors.deepPurple),
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _weekDay(DateTime d) {
    const days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
    return days[d.weekday % 7];
  }

  Widget _buildTasks() {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore.getTasks(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final tasks = snapshot.data!.docs;
        daysWithTasks.clear();

        for (var task in tasks) {
          final data = task.data() as Map<String, dynamic>;
          final date = DateTime.parse(data["date"]);
          daysWithTasks.add("${date.year}-${date.month}-${date.day}");
        }

        final filtered = tasks.where((task) {
          final data = task.data() as Map<String, dynamic>;
          final date = DateTime.parse(data["date"]);
          return isSameDay(date, selectedDay);
        }).toList();

        filtered.sort((a, b) {
          final dataA = a.data() as Map<String, dynamic>;
          final dataB = b.data() as Map<String, dynamic>;
          return dataA["startTime"].compareTo(dataB["startTime"]);
        });

        if (filtered.isEmpty) {
          return Center(
            child: Text(
              "No tasks for this day",
              style: TextStyle(color: Colors.grey, fontSize: 16.sp),
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            final task = filtered[index];
            final data = task.data() as Map<String, dynamic>;
            final taskId = task.id;

            final colorValue = data.containsKey('color') ? data['color'] : 0xFF6C63FF;
            final color = Color(colorValue);
            final status = data['status'] ?? 'inProgress';

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 60.w,
                  child: Text(
                    data["startTime"],
                    style: TextStyle(fontSize: 12.sp),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      width: 10.w,
                      height: 10.h,
                      decoration: BoxDecoration(
                        color: _getStatusColor(status),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Container(
                      width: 2.w,
                      height: 80.h,
                      color: Colors.deepPurple.withOpacity(0.3),
                    ),
                  ],
                ),
                Expanded(
                  child: GestureDetector(
                    onLongPress: () => _showTaskOptions(context, taskId, status),
                    child: TaskCard(
                      title: data["title"],
                      time: "${data["startTime"]} - ${data["endTime"]}",
                      color: color,
                      status: status,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'done':
        return Colors.green;
      case 'inProgress':
        return Colors.deepPurple;
      case 'ongoing':
        return Colors.orange;
      case 'waitingForReview':
        return Colors.blue;
      default:
        return Colors.deepPurple;
    }
  }

  void _showTaskOptions(BuildContext context, String taskId, String currentStatus) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Task Options",
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.h),
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.deepPurple),
                title: const Text("Change Status"),
                onTap: () {
                  Navigator.pop(context);
                  _showStatusPicker(context, taskId, currentStatus);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text("Delete Task", style: TextStyle(color: Colors.red)),
                onTap: () async {
                  Navigator.pop(context);
                  await firestore.deleteTask(taskId);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Task deleted")),
                  );
                },
              ),
              SizedBox(height: 10.h),
            ],
          ),
        );
      },
    );
  }

  void _showStatusPicker(BuildContext context, String taskId, String currentStatus) {
    final statuses = [
      {'value': 'inProgress', 'label': 'In Progress', 'color': Colors.deepPurple},
      {'value': 'ongoing', 'label': 'Ongoing', 'color': Colors.orange},
      {'value': 'waitingForReview', 'label': 'Waiting For Review', 'color': Colors.blue},
      {'value': 'done', 'label': 'Done', 'color': Colors.green},
    ];

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Select Status",
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.h),
              ...statuses.map((status) {
                final isSelected = status['value'] == currentStatus;
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: status['color'] as Color,
                    radius: 8.r,
                  ),
                  title: Text(status['label'] as String),
                  trailing: isSelected ? const Icon(Icons.check, color: Colors.deepPurple) : null,
                  onTap: () async {
                    Navigator.pop(context);
                    await firestore.updateStatus(taskId, status['value'] as String);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Status updated to ${status['label']}")),
                    );
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }
}