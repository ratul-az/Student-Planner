import 'package:flutter/material.dart';

class SubjectsPage extends StatefulWidget {
  const SubjectsPage({super.key});

  @override
  State<SubjectsPage> createState() => _SubjectsPageState();
}

class _SubjectsPageState extends State<SubjectsPage> {
  final List<Map<String, dynamic>> _subjects = [];

  final TextEditingController _subjectController = TextEditingController();
  String _priority = 'Normal';

  void _addSubject() {
    if (_subjectController.text.isEmpty) return;
    setState(() {
      _subjects.add({
        'name': _subjectController.text,
        'priority': _priority,
      });
      _subjectController.clear();
      _priority = 'Normal';
    });
  }

  void _removeSubject(int index) {
    setState(() {
      _subjects.removeAt(index);
    });
  }

  void _editPriority(int index, String newPriority) {
    setState(() {
      _subjects[index]['priority'] = newPriority;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Subjects"), backgroundColor: Colors.orange),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(children: [
              Expanded(
                child: TextField(
                  controller: _subjectController,
                  decoration: const InputDecoration(labelText: 'Subject Name'),
                ),
              ),
              const SizedBox(width: 10),
              DropdownButton<String>(
                value: _priority,
                items: const ['Strong', 'Normal', 'Weak']
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
                onChanged: (value) => setState(() => _priority = value!),
              ),
              IconButton(
                icon: const Icon(Icons.add, color: Colors.green),
                onPressed: _addSubject,
              )
            ]),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _subjects.length,
                itemBuilder: (_, index) {
                  final subject = _subjects[index];
                  return Card(
                    child: ListTile(
                      title: Text(subject['name']),
                      subtitle: Text("Priority: ${subject['priority']}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          DropdownButton<String>(
                            value: subject['priority'],
                            items: const ['Strong', 'Normal', 'Weak']
                                .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                                .toList(),
                            onChanged: (val) => _editPriority(index, val!),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeSubject(index),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
