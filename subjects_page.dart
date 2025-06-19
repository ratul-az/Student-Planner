import 'package:flutter/material.dart';

class SubjectsPage extends StatefulWidget {
  const SubjectsPage({super.key});

  @override
  State<SubjectsPage> createState() => _SubjectsPageState();
}

class _SubjectsPageState extends State<SubjectsPage> {
  final TextEditingController _subjectController = TextEditingController();
  String _priority = 'Normal';
  String _selectedSemester = 'Semester 1';

  final List<String> _semesters = [
    'Semester 1',
    'Semester 2',
    'Semester 3',
    'Semester 4',
  ];

  // Semester -> List of subjects
  final Map<String, List<Map<String, String>>> _semesterSubjects = {};

  @override
  void initState() {
    super.initState();
    for (var sem in _semesters) {
      _semesterSubjects[sem] = [];
    }
  }

  void _addSubject() {
    final subjectName = _subjectController.text.trim();
    if (subjectName.isEmpty) return;

    setState(() {
      _semesterSubjects[_selectedSemester]!.add({
        'name': subjectName,
        'priority': _priority,
      });
      _subjectController.clear();
      _priority = 'Normal';
    });
  }

  void _removeSubject(int index) {
    setState(() {
      _semesterSubjects[_selectedSemester]!.removeAt(index);
    });
  }

  void _editPriority(int index, String newPriority) {
    setState(() {
      _semesterSubjects[_selectedSemester]![index]['priority'] = newPriority;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentSubjects = _semesterSubjects[_selectedSemester]!;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Subjects"),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Semester dropdown
            Row(
              children: [
                const Text("Semester: ", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: _selectedSemester,
                  onChanged: (value) => setState(() => _selectedSemester = value!),
                  items: _semesters
                      .map((sem) => DropdownMenuItem(value: sem, child: Text(sem)))
                      .toList(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Input row
            Row(
              children: [
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
              ],
            ),
            const SizedBox(height: 16),
            // Subject list
            Expanded(
              child: ListView.builder(
                itemCount: currentSubjects.length,
                itemBuilder: (_, index) {
                  final subject = currentSubjects[index];
                  return Card(
                    child: ListTile(
                      title: Text(subject['name']!),
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
            ),
          ],
        ),
      ),
    );
  }
}
