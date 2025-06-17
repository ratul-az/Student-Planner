import 'package:flutter/material.dart';

class TimetablePage extends StatefulWidget {
  const TimetablePage({super.key});

  @override
  State<TimetablePage> createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  DateTime selectedDate = DateTime.now();
  final Map<String, List<String>> schedule = {};
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _readableDate(DateTime date) {
    return '${_weekdayName(date.weekday)}, ${date.day}-${date.month}-${date.year}';
  }

  String _weekdayName(int weekday) {
    const names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return names[weekday - 1];
  }

  void _addClassDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Add class for ${_readableDate(selectedDate)}"),
        content: TextField(
          controller: _controller,
          decoration: const InputDecoration(
            labelText: "Class Name & Time",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _controller.clear();
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final text = _controller.text.trim();
              if (text.isNotEmpty) {
                final key = _formatDate(selectedDate);
                setState(() {
                  schedule.putIfAbsent(key, () => []);
                  schedule[key]!.add(text);
                });
                _controller.clear();
                Navigator.pop(context);
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final key = _formatDate(selectedDate);
    final todayClasses = schedule[key] ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text("Timetable & Schedule")),
      body: Column(
        children: [
          CalendarDatePicker(
            initialDate: selectedDate,
            firstDate: DateTime(2020),
            lastDate: DateTime(2035),
            onDateChanged: (date) => setState(() => selectedDate = date),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _readableDate(selectedDate),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: _addClassDialog,
                  icon: const Icon(Icons.add),
                  label: const Text("Add Class"),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: todayClasses.isEmpty
                ? const Center(child: Text("No classes scheduled"))
                : ListView.builder(
                    itemCount: todayClasses.length,
                    itemBuilder: (_, index) => ListTile(
                      leading: const Icon(Icons.schedule),
                      title: Text(todayClasses[index]),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() => todayClasses.removeAt(index));
                        },
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
