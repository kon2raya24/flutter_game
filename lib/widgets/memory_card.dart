import 'dart:ui';
import 'dart:math';
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
    final displayEmoji = flipped ? emoji : '';

    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 1,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            final rotate = Tween(begin: pi, end: 0.0).animate(animation);
            return AnimatedBuilder(
              animation: rotate,
              child: child,
              builder: (context, child) {
                return Transform(
                  transform: Matrix4.rotationY(rotate.value),
                  alignment: Alignment.center,
                  child: child,
                );
              },
            );
          },
          child: Container(
            key: ValueKey<String>(displayEmoji),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 6,
                  offset: const Offset(2, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                child: Container(
                  decoration: BoxDecoration(
                    color: flipped
                        ? Colors.white.withValues(alpha: 0.8)
                        : Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.4),
                      width: 1,
                    ),
                  ),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    displayEmoji,
                    style: const TextStyle(
                      fontSize: 36,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          offset: Offset(1, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
