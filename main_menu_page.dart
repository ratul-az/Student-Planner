import 'package:flutter/material.dart';
import 'package:flutter_application_1/task.dart';
import 'package:flutter_application_1/timetable.dart';
import 'package:flutter_application_1/note_list.dart';
import 'package:flutter_application_1/mood_quiz_page.dart';
import 'package:flutter_application_1/profile_page.dart';
import 'package:flutter_application_1/result_page.dart';
import 'package:flutter_application_1/subjects_page.dart';
import 'package:flutter_application_1/reminder_page.dart';
import 'package:flutter_application_1/sign_in_page.dart'; // Make sure this exists

class MainMenuPage extends StatefulWidget {
  final String username;
  const MainMenuPage({super.key, required this.username});

  @override
  State<MainMenuPage> createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? latestTask;
  DateTime? taskDeadline;

  void setReminder(String taskTitle, DateTime deadline) {
    setState(() {
      latestTask = taskTitle;
      taskDeadline = deadline;
    });
  }

  String _countdownText() {
    if (taskDeadline == null) return "";
    final diff = taskDeadline!.difference(DateTime.now());
    if (diff.isNegative) return "Time's up!";
    final hours = diff.inHours;
    final minutes = diff.inMinutes % 60;
    if (hours > 0) {
      return "$hours hr ${minutes.toString().padLeft(2, '0')} min left";
    } else {
      return "$minutes min left";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.orange),
              child: Text('Student Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            _drawerItem(Icons.score, 'Result', () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ResultPage()));
            }),
            _drawerItem(Icons.subject, 'Subjects', () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SubjectsPage()));
            }),
          ],
        ),
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const CircleAvatar(radius: 40, child: Icon(Icons.person, size: 50)),
            const SizedBox(height: 10),
            Text(widget.username, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text("Edit Profile"),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ProfilePage(username: widget.username)),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Sign Out"),
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const SignInPage()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Welcome back, ${widget.username}'),
        backgroundColor: Colors.orange,
        leading: IconButton(icon: const Icon(Icons.menu), onPressed: () => _scaffoldKey.currentState!.openDrawer()),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => _scaffoldKey.currentState!.openEndDrawer(),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (latestTask != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.orange.shade100, borderRadius: BorderRadius.circular(12)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Reminder: $latestTask", style: const TextStyle(fontWeight: FontWeight.w600)),
                    Text(_countdownText(), style: const TextStyle(color: Colors.redAccent)),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _gridItem(Icons.assignment, 'Tasks & Assignments', TaskScreen(onTaskAdded: setReminder)),
                  _gridItem(Icons.calendar_today, 'Timetable & Schedule', const TimetablePage()),
                  _gridItem(Icons.notes, 'Notes & Study Materials', const NoteListPage()),
                  _gridItem(Icons.mood, 'Mood Tracker', MoodQuizPage()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(leading: Icon(icon), title: Text(title), onTap: onTap);
  }

  Widget _gridItem(IconData icon, String label, Widget page) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.orange),
            const SizedBox(height: 12),
            Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
