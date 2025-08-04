import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class ConfettiStars extends StatefulWidget {
  const ConfettiStars({super.key});

  @override
  State<ConfettiStars> createState() => _ConfettiStarsState();
}

class _ConfettiStarsState extends State<ConfettiStars>
    with TickerProviderStateMixin {
  final List<_Star> _stars = [];
  final Random _random = Random();
  Timer? _spawnTimer;

  @override
  void initState() {
    super.initState();
    _spawnTimer = Timer.periodic(
      const Duration(milliseconds: 500),
      (_) => _spawnStar(),
    );
  }

  void _spawnStar() {
    final size = MediaQuery.of(context).size;
    final star = _Star(
      key: UniqueKey(),
      x: _random.nextDouble() * size.width,
      delay: Duration(milliseconds: _random.nextInt(2000)),
      icon: _random.nextBool() ? '⭐' : '✨',
    );
    setState(() => _stars.add(star));

    // Remove after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() => _stars.remove(star));
      }
    });
  }

  @override
  void dispose() {
    _spawnTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: _stars);
  }
}

class _Star extends StatefulWidget {
  final double x;
  final Duration delay;
  final String icon;

  const _Star({
    required Key key,
    required this.x,
    required this.delay,
    required this.icon,
  }) : super(key: key);

  @override
  State<_Star> createState() => _StarState();
}

class _StarState extends State<_Star> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    _animation = Tween<double>(
      begin: -30,
      end: MediaQuery.of(context).size.height + 30,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) {
        return Positioned(
          left: Random().nextDouble() * screenSize.width,
          top: Random().nextDouble() * screenSize.height,
          child: Icon(Icons.star, color: Colors.yellowAccent),
        );
      },
    );
  }
}
