import 'package:flutter/material.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _cgpaController = TextEditingController();

  String _selectedSemester = 'Semester 1';

  final List<String> _semesters = [
    'Semester 1',
    'Semester 2',
    'Semester 3',
    'Semester 4',
  ];

  // Map: Semester name -> List of results
  final Map<String, List<Map<String, dynamic>>> _semesterResults = {};

  @override
  void initState() {
    super.initState();
    for (var sem in _semesters) {
      _semesterResults[sem] = [];
    }
  }

  void _addResult() {
    final subject = _subjectController.text.trim();
    final cgpaText = _cgpaController.text.trim();

    if (subject.isEmpty || cgpaText.isEmpty) return;

    final cgpa = double.tryParse(cgpaText);
    if (cgpa == null || cgpa < 0.0 || cgpa > 4.0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter valid CGPA (0.0 to 4.0)")),
      );
      return;
    }

    setState(() {
      _semesterResults[_selectedSemester]!.add({
        'subject': subject,
        'cgpa': cgpa,
      });
      _subjectController.clear();
      _cgpaController.clear();
    });
  }

  void _removeResult(int index) {
    setState(() {
      _semesterResults[_selectedSemester]!.removeAt(index);
    });
  }

  double _calculateAverageCGPA() {
    final results = _semesterResults[_selectedSemester]!;
    if (results.isEmpty) return 0.0;
    double total = results.fold(0.0, (sum, item) => sum + item['cgpa']);
    return total / results.length;
  }

  @override
  Widget build(BuildContext context) {
    final currentResults = _semesterResults[_selectedSemester]!;
    final averageGPA = _calculateAverageCGPA();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Semester-wise CGPA"),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Dropdown for selecting semester
            DropdownButton<String>(
              value: _selectedSemester,
              onChanged: (value) {
                setState(() {
                  _selectedSemester = value!;
                });
              },
              items: _semesters.map((sem) {
                return DropdownMenuItem(
                  value: sem,
                  child: Text(sem),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            // Input row
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _subjectController,
                    decoration: const InputDecoration(labelText: 'Subject'),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 80,
                  child: TextField(
                    controller: _cgpaController,
                    decoration: const InputDecoration(labelText: 'CGPA'),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.green),
                  onPressed: _addResult,
                )
              ],
            ),
            const SizedBox(height: 16),
            // Result list
            Expanded(
              child: ListView.builder(
                itemCount: currentResults.length,
                itemBuilder: (_, index) {
                  final result = currentResults[index];
                  return Card(
                    child: ListTile(
                      title: Text(result['subject']),
                      trailing: Text(
                        result['cgpa'].toStringAsFixed(2),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onLongPress: () => _removeResult(index),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            // Average CGPA
            Text(
              "Average CGPA (${_selectedSemester}): ${averageGPA.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

