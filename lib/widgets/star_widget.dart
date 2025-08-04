import 'dart:math';
import 'package:flutter/material.dart';

class Star extends StatefulWidget {
  const Star({super.key});

  @override
  State<Star> createState() => _StarState();
}

class _StarState extends State<Star> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final Random _random = Random();
  late double _left;
  late double _top;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 1000 + _random.nextInt(2000)),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    _left = _random.nextDouble() * size.width;
    _top = _random.nextDouble() * size.height;

    return Positioned(
      left: _left,
      top: _top,
      child: FadeTransition(
        opacity: _animation,
        child: Icon(
          Icons.star,
          // ignore: deprecated_member_use
          color: Colors.yellowAccent.withOpacity(0.8),
          size: 12 + _random.nextDouble() * 12,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
