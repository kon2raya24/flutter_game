import 'package:flutter/material.dart';

class MemoryCard extends StatelessWidget {
  final String emoji;
  final bool flipped;
  final VoidCallback onTap;

  const MemoryCard({
    super.key,
    required this.emoji,
    required this.flipped,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: flipped ? Colors.white : Colors.blueAccent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          flipped ? emoji : '❓',
          style: const TextStyle(fontSize: 32),
        ),
      ),
    );
  }
}
