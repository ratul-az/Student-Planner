import 'package:flutter/material.dart';
import 'mood_questions.dart';
import 'mood_result_page.dart';

class MoodQuizPage extends StatefulWidget {
  @override
  _MoodQuizPageState createState() => _MoodQuizPageState();
}

class _MoodQuizPageState extends State<MoodQuizPage> {
  int current = 0;
  List<int> scores = [];

  void _answer(int score) {
    scores.add(score);
    if (current < moodQuestions.length - 1) {
      setState(() => current++);
    } else {
      final total = scores.reduce((a, b) => a + b);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MoodResultPage(score: total)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = moodQuestions[current];
    return Scaffold(
      appBar: AppBar(title: const Text("Mood Tracker")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Question ${current + 1}/${moodQuestions.length}",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 12),
            Text(q['question'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ...List.generate(q['options'].length, (i) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: () => _answer(q['scores'][i]),
                  child: Text(q['options'][i], style: const TextStyle(fontSize: 16)),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
