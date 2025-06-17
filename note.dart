import 'package:flutter/material.dart';

class NotePage extends StatelessWidget {
  final String? initialText;

  const NotePage({super.key, this.initialText});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: initialText);

    return Scaffold(
      appBar: AppBar(title: const Text("Write a Note")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller,
              maxLines: 10,
              decoration: const InputDecoration(
                hintText: "Write your note here...",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  Navigator.pop(context, controller.text.trim());
                }
              },
              icon: const Icon(Icons.save),
              label: const Text("Save"),
            )
          ],
        ),
      ),
    );
  }
}
