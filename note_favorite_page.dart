import 'package:flutter/material.dart';

class NoteFavoritePage extends StatelessWidget {
  final List<String> favorites;

  const NoteFavoritePage({super.key, required this.favorites});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorite Notes")),
      body: favorites.isEmpty
          ? const Center(child: Text("No favorite notes yet."))
          : ListView.separated(
              itemCount: favorites.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (_, index) => ListTile(
                leading: const Icon(Icons.star, color: Colors.amber),
                title: Text(favorites[index]),
              ),
            ),
    );
  }
}
