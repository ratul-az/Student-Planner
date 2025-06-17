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
        child: Text(
          "Task: $task\nTime left: ${minutesLeft > 0 ? '$minutesLeft minutes' : 'Time’s up!'}",
          style: const TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
