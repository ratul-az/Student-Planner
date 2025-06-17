import 'package:flutter/material.dart';

class MoodResultPage extends StatelessWidget {
  final int score;
  const MoodResultPage({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    String mood;
    String message;
    Color bgColor;

    if (score <= 20) {
      mood = "Low";
      message = "You seem a bit down today. Try getting rest, fresh air, or talking to a friend.";
      bgColor = Colors.blueGrey;
    } else if (score <= 35) {
      mood = "Moderate";
      message = "You're doing okay. Stay mindful and take breaks when needed.";
      bgColor = Colors.amber;
    } else {
      mood = "Positive";
      message = "Great mood! Keep up your good habits and positive vibes!";
      bgColor = Colors.green;
    }

    return Scaffold(
      backgroundColor: bgColor.withOpacity(0.1), // fixed
      appBar: AppBar(title: const Text("Your Mood")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Total Mood Score: $score",
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              Text("Mood Level: $mood",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: bgColor)),
              const SizedBox(height: 24),
              Text(
                message,
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text("Back to Menu"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
