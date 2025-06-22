import 'package:flutter/material.dart';

class NotePage extends StatefulWidget {
  final String? initialText;

  const NotePage({super.key, this.initialText});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  late TextEditingController controller;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initialText);
  }

  @override
  Widget build(BuildContext context) {
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
            const SizedBox(height: 10),
            Row(
              children: [
                Checkbox(
                  value: isFavorite,
                  onChanged: (value) {
                    setState(() {
                      isFavorite = value ?? false;
                    });
                  },
                ),
                const Text("Mark as Favorite"),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  Navigator.pop(context, {
                    'text': controller.text.trim(),
                    'isFavorite': isFavorite,
                  });
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
