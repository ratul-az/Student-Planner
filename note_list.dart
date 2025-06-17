import 'package:flutter/material.dart';
import 'note.dart';

class NoteListPage extends StatefulWidget {
  const NoteListPage({super.key});

  @override
  State<NoteListPage> createState() => _NoteListPageState();
}

class _NoteListPageState extends State<NoteListPage> {
  List<String> notes = [];

  void _addNote() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NotePage()),
    );
    if (result != null && result is String) {
      setState(() => notes.add(result));
    }
  }

  void _editNote(int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => NotePage(initialText: notes[index])),
    );
    if (result != null && result is String) {
      setState(() => notes[index] = result);
    }
  }

  void _deleteNote(int index) {
    setState(() => notes.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notes & Study Materials")),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        child: const Icon(Icons.add),
      ),
      body: notes.isEmpty
          ? const Center(child: Text("No notes yet."))
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (_, index) => ListTile(
                title: Text(notes[index]),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: const Icon(Icons.edit), onPressed: () => _editNote(index)),
                    IconButton(icon: const Icon(Icons.delete), onPressed: () => _deleteNote(index)),
                  ],
                ),
              ),
            ),
    );
  }
}
