import 'package:flutter/material.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  final List<Map<String, String>> _results = [];

  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();

  void _addResult() {
    if (_subjectController.text.isEmpty || _gradeController.text.isEmpty) return;
    setState(() {
      _results.add({
        'subject': _subjectController.text,
        'grade': _gradeController.text.toUpperCase(),
      });
      _subjectController.clear();
      _gradeController.clear();
    });
  }

  void _removeResult(int index) {
    setState(() {
      _results.removeAt(index);
    });
  }

  double _calculateGPA() {
    double total = 0;
    for (var result in _results) {
      switch (result['grade']) {
        case 'A+':
        case 'A':
          total += 4.0;
          break;
        case 'A-':
          total += 3.7;
          break;
        case 'B+':
          total += 3.3;
          break;
        case 'B':
          total += 3.0;
          break;
        case 'C+':
          total += 2.3;
          break;
        case 'C':
          total += 2.0;
          break;
        default:
          total += 0;
      }
    }
    return _results.isEmpty ? 0.0 : total / _results.length;
  }

  @override
  Widget build(BuildContext context) {
    final gpa = _calculateGPA();
    return Scaffold(
      appBar: AppBar(title: const Text("My Results"), backgroundColor: Colors.orange),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(children: [
              Expanded(
                child: TextField(
                  controller: _subjectController,
                  decoration: const InputDecoration(labelText: 'Subject'),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 70,
                child: TextField(
                  controller: _gradeController,
                  decoration: const InputDecoration(labelText: 'Grade'),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add, color: Colors.green),
                onPressed: _addResult,
              )
            ]),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _results.length,
                itemBuilder: (_, index) {
                  final result = _results[index];
                  return Card(
                    child: ListTile(
                      title: Text(result['subject']!),
                      trailing: Text(result['grade']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                      onLongPress: () => _removeResult(index),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Text("GPA: ${gpa.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepOrange)),
          ],
        ),
      ),
    );
  }
}
