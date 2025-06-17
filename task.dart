import 'package:flutter/material.dart';

class TaskScreen extends StatefulWidget {
  final Function(String, DateTime) onTaskAdded;
  const TaskScreen({super.key, required this.onTaskAdded});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final TextEditingController _taskController = TextEditingController();
  TimeOfDay? _selectedTime;

  void _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  void _addTask() {
    if (_taskController.text.isEmpty || _selectedTime == null) return;

    final now = DateTime.now();
    final deadline = DateTime(now.year, now.month, now.day, _selectedTime!.hour, _selectedTime!.minute);

    widget.onTaskAdded(_taskController.text, deadline);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Task'), backgroundColor: Colors.orange),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _taskController,
              decoration: const InputDecoration(labelText: 'Task Title'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _pickTime,
                  child: const Text('Pick Task Time'),
                ),
                const SizedBox(width: 12),
                if (_selectedTime != null)
                  Text('Selected: ${_selectedTime!.format(context)}'),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _addTask,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: const Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}

