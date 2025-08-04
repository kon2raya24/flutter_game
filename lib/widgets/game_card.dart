import 'package:flutter/material.dart';

class GameCard extends StatelessWidget {
  final String title;
  final String route;

  const GameCard({super.key, required this.title, required this.route});

  void _onTap(BuildContext context) {
    Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onTap(context),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        margin: const EdgeInsets.all(12),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors
                    .primaries[title.length % Colors.primaries.length]
                    .shade200,
                Colors
                    .primaries[(title.length + 4) % Colors.primaries.length]
                    .shade100,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_getEmoji(title), style: const TextStyle(fontSize: 42)),
                const SizedBox(height: 10),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'ComicSans',
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getEmoji(String title) {
    final emojis = {
      'Memory Match': '🧠',
      'Shape Tap': '🔺',
      'Draw Board': '🎨',
    };
    return emojis[title] ?? '🎮';
  }
}
