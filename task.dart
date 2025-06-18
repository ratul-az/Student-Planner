import 'package:flutter/material.dart';

class TaskScreen extends StatefulWidget {
  final Function(String, DateTime)? onTaskAdded; // optional callback
  const TaskScreen({super.key, this.onTaskAdded});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final TextEditingController _taskController = TextEditingController();
  TimeOfDay? _selectedTime;

  final List<Map<String, dynamic>> _tasks = [];

  void _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  void _addTask({bool setReminder = false}) {
    if (_taskController.text.isEmpty || _selectedTime == null) return;

    final now = DateTime.now();
    final deadline = DateTime(now.year, now.month, now.day, _selectedTime!.hour, _selectedTime!.minute);

    setState(() {
      _tasks.add({
        'title': _taskController.text,
        'time': _selectedTime,
        'deadline': deadline,
      });
    });

    if (setReminder && widget.onTaskAdded != null) {
      widget.onTaskAdded!(_taskController.text, deadline);
    }

    _taskController.clear();
    _selectedTime = null;
  }

  void _editTask(int index) {
    final existing = _tasks[index];
    _taskController.text = existing['title'];
    _selectedTime = existing['time'];

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Task"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _taskController,
              decoration: const InputDecoration(labelText: 'Task Title'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _pickTime,
              child: const Text("Pick New Time"),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              if (_taskController.text.isNotEmpty && _selectedTime != null) {
                final now = DateTime.now();
                final deadline = DateTime(now.year, now.month, now.day, _selectedTime!.hour, _selectedTime!.minute);
                setState(() {
                  _tasks[index] = {
                    'title': _taskController.text,
                    'time': _selectedTime,
                    'deadline': deadline,
                  };
                });
              }
              Navigator.pop(context);
            },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }

  void _deleteTask(int index) {
    setState(() => _tasks.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tasks & Assignments'), backgroundColor: Colors.orange),
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
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => _addTask(setReminder: false),
                  child: const Text('Add to History'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  onPressed: () => _addTask(setReminder: true),
                  child: const Text('Add and Set Reminder'),
                ),
              ],
            ),
            const Divider(height: 32),
            Expanded(
              child: _tasks.isEmpty
                  ? const Center(child: Text("No tasks yet."))
                  : ListView.builder(
                      itemCount: _tasks.length,
                      itemBuilder: (_, index) {
                        final task = _tasks[index];
                        return ListTile(
                          title: Text(task['title']),
                          subtitle: Text("Time: ${task['time']?.format(context)}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(icon: const Icon(Icons.edit), onPressed: () => _editTask(index)),
                              IconButton(icon: const Icon(Icons.delete), onPressed: () => _deleteTask(index)),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}


  

