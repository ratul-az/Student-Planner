import 'package:flutter/material.dart';

class ReminderPage extends StatelessWidget {
  final String task;
  final DateTime deadline;

  const ReminderPage({super.key, required this.task, required this.deadline});

  @override
  Widget build(BuildContext context) {
    final duration = deadline.difference(DateTime.now());
    final minutesLeft = duration.inMinutes;

    return Scaffold(
      appBar: AppBar(title: const Text("Task Reminder"), backgroundColor: Colors.orange),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Task: $task",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                "Time left: ${minutesLeft > 0 ? '$minutesLeft minutes' : 'Time’s up!'}",
                style: const TextStyle(fontSize: 18, color: Colors.redAccent),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

