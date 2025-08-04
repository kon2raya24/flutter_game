import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
// or custom list card

class GameSelector extends StatelessWidget {
  const GameSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background animation
          SizedBox.expand(
            child: Lottie.asset(
              'assets/animations/stars.json',
              fit: BoxFit.cover,
              repeat: true,
            ),
          ),
          // Foreground content
          Column(
            children: [
              AppBar(
                title: const Text(
                  "Select a Game",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: const [
                    _GameListTile(title: "Memory Match", route: '/memory'),
                    _GameListTile(title: "Shape Tap", route: '/shapeTap'),
                    _GameListTile(title: "Draw Board", route: '/draw'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GameListTile extends StatelessWidget {
  final String title;
  final String route;

  const _GameListTile({required this.title, required this.route});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withValues(alpha: 0.9),
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 14,
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () => Navigator.pushNamed(context, route),
      ),
    );
  }
}
