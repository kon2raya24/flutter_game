// memory_card.dart
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class MemoryCard extends StatefulWidget {
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
  State<MemoryCard> createState() => _MemoryCardState();
}

class _MemoryCardState extends State<MemoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(MemoryCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.flipped != oldWidget.flipped) {
      if (widget.flipped) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AspectRatio(
        aspectRatio: 1,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            final isFront = _animation.value >= 0.5;
            final angle = _animation.value * pi;
            final displayEmoji = widget.emoji;

            return Transform(
              transform: Matrix4.rotationY(angle),
              alignment: Alignment.center,
              child: isFront ? _buildFront(displayEmoji) : _buildBack(context),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFront(String emoji) {
    return Container(
      decoration: _cardDecoration(Colors.white),
      alignment: Alignment.center,
      child: Text(
        emoji,
        style: const TextStyle(
          fontSize: 36,
          shadows: [
            Shadow(color: Colors.black26, offset: Offset(1, 1), blurRadius: 2),
          ],
        ),
      ),
    );
  }

  Widget _buildBack(BuildContext context) {
    return Container(
      decoration: _cardDecoration(
        Theme.of(context).colorScheme.primary.withOpacity(0.3),
      ),
      alignment: Alignment.center,
      child: const Text(
        '',
        style: TextStyle(fontSize: 30, color: Colors.white),
      ),
    );
  }

  BoxDecoration _cardDecoration(Color color) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [
        BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 4)),
      ],
      border: Border.all(color: Colors.white.withOpacity(0.4), width: 1),
    );
  }
}
