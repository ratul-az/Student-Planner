import 'package:flutter/material.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  final List<Map<String, dynamic>> _results = [];

  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _cgpaController = TextEditingController();

  void _addResult() {
    final subject = _subjectController.text.trim();
    final cgpaText = _cgpaController.text.trim();

    if (subject.isEmpty || cgpaText.isEmpty) return;

    final cgpa = double.tryParse(cgpaText);
    if (cgpa == null || cgpa < 0 || cgpa > 4.0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter valid CGPA (0.0 to 4.0)")),
      );
      return;
    }

    setState(() {
      _results.add({
        'subject': subject,
        'cgpa': cgpa,
      });
      _subjectController.clear();
      _cgpaController.clear();
    });
  }

  void _removeResult(int index) {
    setState(() {
      _results.removeAt(index);
    });
  }

  double _calculateAverageCGPA() {
    if (_results.isEmpty) return 0.0;
    double total = _results.fold(0.0, (sum, item) => sum + item['cgpa']);
    return total / _results.length;
  }

  @override
  Widget build(BuildContext context) {
    final averageGPA = _calculateAverageCGPA();

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Results"),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
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
            Expanded(
              child: ListView.builder(
                itemCount: _results.length,
                itemBuilder: (_, index) {
                  final result = _results[index];
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
            Text(
              "Average CGPA: ${averageGPA.toStringAsFixed(2)}",
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
