import 'package:flutter/material.dart';
import '../../../../core/services/firestore_service.dart';

class AddTaskScreen extends StatefulWidget {
  final DateTime date;

  const AddTaskScreen({super.key, required this.date});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final titleController = TextEditingController();
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  final firestore = FirestoreService();

  Color selectedColor = Colors.deepPurple;
  DateTime selectedDate = DateTime.now();
  String selectedStatus = 'inProgress';

  final List<Map<String, dynamic>> statusOptions = [
    {'value': 'inProgress', 'label': 'In Progress', 'color': Colors.deepPurple},
    {'value': 'ongoing', 'label': 'Ongoing', 'color': Colors.orange},
    {'value': 'waitingForReview', 'label': 'Waiting For Review', 'color': Colors.blue},
    {'value': 'done', 'label': 'Done', 'color': Colors.green},
  ];

  @override
  void initState() {
    super.initState();
    selectedDate = widget.date;
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  Future<void> _saveTask() async {
    if (titleController.text.isEmpty || startTime == null || endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    try {
      await firestore.addTask(
        title: titleController.text,
        date: selectedDate,
        startTime: startTime!.format(context),
        endTime: endTime!.format(context),
        color: selectedColor,
        status: selectedStatus,
      );

      // 👇 يرجع بعد الحفظ
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Task"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// TITLE
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Task Title",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              /// DATE
              ElevatedButton.icon(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() => selectedDate = picked);
                  }
                },
                icon: const Icon(Icons.calendar_today),
                label: Text(
                  "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}",
                ),
              ),

              const SizedBox(height: 20),

              /// TIME
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );

                        if (picked != null) {
                          final now = DateTime.now();
                          final selectedDateTime = DateTime(
                            selectedDate.year,
                            selectedDate.month,
                            selectedDate.day,
                            picked.hour,
                            picked.minute,
                          );

                          if (selectedDateTime.isBefore(now)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("مينفعش تختار وقت في الماضي")),
                            );
                            return;
                          }

                          setState(() {
                            startTime = picked;
                            endTime = null;
                          });
                        }
                      },
                      icon: const Icon(Icons.access_time),
                      label: Text(
                        startTime == null
                            ? "Start Time"
                            : startTime!.format(context),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: startTime == null
                          ? null
                          : () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: startTime!,
                        );

                        if (picked != null) {
                          final start = DateTime(
                            selectedDate.year,
                            selectedDate.month,
                            selectedDate.day,
                            startTime!.hour,
                            startTime!.minute,
                          );

                          final end = DateTime(
                            selectedDate.year,
                            selectedDate.month,
                            selectedDate.day,
                            picked.hour,
                            picked.minute,
                          );

                          if (end.isBefore(start)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("وقت النهاية لازم يكون بعد البداية"),
                              ),
                            );
                            return;
                          }

                          setState(() => endTime = picked);
                        }
                      },
                      icon: const Icon(Icons.access_time_filled),
                      label: Text(
                        endTime == null
                            ? "End Time"
                            : endTime!.format(context),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// COLORS
              const Text("Color:", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _colorItem(Colors.deepPurple),
                  _colorItem(Colors.blue),
                  _colorItem(Colors.orange),
                  _colorItem(Colors.pink),
                  _colorItem(Colors.green),
                ],
              ),

              const SizedBox(height: 20),

              /// STATUS
              const Text("Status:", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: statusOptions.map((status) {
                  final isSelected = selectedStatus == status['value'];

                  return ChoiceChip(
                    label: Text(status['label']),
                    selected: isSelected,
                    selectedColor:
                    (status['color'] as Color).withOpacity(0.2),
                    backgroundColor: Colors.grey.shade200,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? status['color'] as Color
                          : Colors.black,
                      fontWeight:
                      isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    onSelected: (_) {
                      setState(() =>
                      selectedStatus = status['value'] as String);
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 30),

              /// SAVE BUTTON
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveTask,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Save Task"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _colorItem(Color color) {
    return GestureDetector(
      onTap: () => setState(() => selectedColor = color),
      child: CircleAvatar(
        backgroundColor: color,
        radius: 20,
        child: selectedColor == color
            ? const Icon(Icons.check, color: Colors.white, size: 20)
            : null,
      ),
    );
  }
}