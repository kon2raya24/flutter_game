import 'package:flutter/material.dart';
import '../widgets/game_card.dart';

class GameSelector extends StatelessWidget {
  const GameSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "🎉 Let's Play!",
          style: TextStyle(
            fontFamily: 'ComicSans',
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(2, 2),
              ),
            ],
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.purpleAccent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFB2EBF2), // Light cyan
              Color(0xFFCE93D8), // Light purple
              Color(0xFFFFF176), // Yellow
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          padding: const EdgeInsets.all(16),
          children: const [
            GameCard(title: "Memory Match", route: '/memory'),
            GameCard(title: "Shape Tap", route: '/shapeTap'),
            GameCard(title: "Draw Board", route: '/draw'),
          ],
        ),
      ),
    );
  }
}
