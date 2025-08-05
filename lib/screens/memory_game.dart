import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

extension ColorUtils on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);

    // 2) clamp() returns num, so convert to double
    final newLightness = (hsl.lightness - amount).clamp(0.0, 1.0).toDouble();

    final darkerHsl = hsl.withLightness(newLightness);
    return darkerHsl.toColor();
  }
}

class MemoryGame extends StatefulWidget {
  const MemoryGame({super.key});

  @override
  State<MemoryGame> createState() => _MemoryGameState();
}

class _MemoryGameState extends State<MemoryGame>
    with SingleTickerProviderStateMixin {
  late final AnimationController _buttonController;

  @override
  void initState() {
    super.initState();
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _buttonController.dispose();
    super.dispose();
  }

  static const _allEmojis = [
    '🐶',
    '🐱',
    '🐭',
    '🐹',
    '🐰',
    '🦊',
    '🐻',
    '🐼',
    '🐨',
    '🐯',
    '🦁',
    '🐮',
    '🐷',
    '🐸',
    '🐵',
    '🐔',
    '🦄',
    '🐝',
    '🐢',
    '🐬',
    '🐙',
    '🦀',
    '🐞',
    '🦋',
    '🌷',
    '🌹',
    '🌻',
    '🌼',
    '🌸',
    '🌵',
    '🍄',
    '🌲',
    '🌈',
    '⭐️',
    '⚽️',
    '🏀',
    '🎲',
    '🎯',
    '🎵',
    '🎸',
  ];

  List<String> _shuffledEmojis = [];
  List<bool> _isFlipped = [];
  List<bool> _isMatched = [];

  int? _firstSelectedIndex;
  int _moves = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final totalCards = _shuffledEmojis.length;

          // 1) No board yet → animated prompt + refresh button
          if (totalCards == 0) {
            return Stack(
              children: [
                Positioned.fill(
                  child: Opacity(
                    opacity: 1,
                    child: Lottie.asset(
                      'assets/animations/stars.json',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Center(
                  child: ScaleTransition(
                    scale: Tween(begin: 1.0, end: 1.1).animate(
                      CurvedAnimation(
                        parent: _buttonController,
                        curve: Curves.easeInOut,
                      ),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFF8A65), // coral orange
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 10,
                      ),
                      onPressed: () {
                        _showLevelDialog();
                      },
                      child: const Text(
                        "Let's Choose a Level!",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: ElevatedButton(
                //     onPressed: _showLevelDialog,
                //     child: Text(
                //       'Please select a level',
                //       style: TextStyle(
                //         fontSize: 24,
                //         color: Colors.white,
                //         fontWeight: FontWeight.bold,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            );
          }

          // 2) Compute grid shape
          final (columns, rows) = _calculateGridDimensions(totalCards);
          const spacing = 8.0;
          final maxW = constraints.maxWidth;
          final maxH = constraints.maxHeight;

          // 3) Perfect square sizing
          final cellSize = min(maxW / columns, maxH / rows);
          final gridW = cellSize * columns + spacing * (columns - 1);
          final gridH = cellSize * rows + spacing * (rows - 1);

          // 4) HUD + centered grid
          return Stack(
            children: [
              Positioned.fill(
                child: Opacity(
                  opacity: 1,
                  child: Lottie.asset(
                    'assets/animations/stars.json',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    // Fill background color behind SafeArea HUD
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Moves: $_moves',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            'Pairs: ${_matchedPairs()}/${totalCards ~/ 2}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.refresh,
                              color: Colors.white,
                            ),
                            onPressed: _showLevelDialog,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    // Game board
                    Expanded(
                      child: Center(
                        child: SizedBox(
                          width: gridW,
                          height: gridH,
                          child: GridView.builder(
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: totalCards,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: columns,
                                  crossAxisSpacing: spacing,
                                  mainAxisSpacing: spacing,
                                  childAspectRatio: 1, // always squares
                                ),
                            itemBuilder: (context, idx) {
                              return MemoryCard(
                                emoji: _shuffledEmojis[idx],
                                flipped: _isFlipped[idx] || _isMatched[idx],
                                onTap: () => _onCardTap(idx),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showLevelDialog() {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: const Color.fromARGB(0, 255, 255, 255),
          title: Center(
            child: Text(
              'Pick Your Adventure!',
              style: TextStyle(
                fontSize: 24,
                color: Color.fromARGB(255, 255, 255, 255), // coral orange
                fontWeight: FontWeight.bold,
                fontFamily: 'ComicSans',
              ),
            ),
          ),
          contentPadding: EdgeInsets.zero,
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),

                _levelTile('Easy', 4, Colors.teal[100]!),
                const SizedBox(height: 10),

                _levelTile('Beginner', 8, Colors.lightGreen[800]!),
                const SizedBox(height: 10),

                _levelTile('Medium', 12, Colors.amber[200]!),
                const SizedBox(height: 10),

                _levelTile('Hard', 16, Colors.deepOrange[200]!),
                const SizedBox(height: 10),

                _levelTile('Extreme', 20, Colors.redAccent[100]!),
                const SizedBox(height: 10),

                _levelTile('Super', 24, Colors.purple[100]!),
                const SizedBox(height: 10),

                _levelTile('Ultra', 32, Colors.pink[100]!),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _levelTile(String label, int count, Color bgColor) {
    final emoji = _emojiForLabel(label);
    return Material(
      color: bgColor,
      elevation: 2,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () {
          _generateBoard(count);
          Navigator.pop(context);
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '$label ($count cards)',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'ComicSans',
                    color: bgColor.darken(0.3),
                  ),
                ),
              ),
              Icon(Icons.chevron_right, size: 28, color: bgColor.darken(0.4)),
            ],
          ),
        ),
      ),
    );
  }

  // 1) Expanded emoji mapper
  String _emojiForLabel(String label) {
    switch (label.toLowerCase()) {
      case 'easy':
        return '🐣';
      case 'beginner':
        return '🦋';
      case 'medium':
        return '🌞';
      case 'hard':
        return '🔥';
      case 'extreme':
        return '🚀';
      case 'super':
        return '🦄';
      case 'ultra':
        return '🌟';
      default:
        return '🎲';
    }
  }

  void _generateBoard(int totalTiles) {
    assert(totalTiles.isEven, 'Total tiles must be even');
    final rnd = Random();
    final pairCount = totalTiles ~/ 2;

    final pool = List<String>.from(_allEmojis)..shuffle(rnd);
    final pairs = pool.take(pairCount).toList();

    _shuffledEmojis = [...pairs, ...pairs]..shuffle(rnd);
    _isFlipped = List<bool>.filled(totalTiles, false);
    _isMatched = List<bool>.filled(totalTiles, false);
    _firstSelectedIndex = null;
    _moves = 0;

    setState(() {});
  }

  void _onCardTap(int index) {
    if (_isMatched[index] || _isFlipped[index]) return;

    setState(() => _isFlipped[index] = true);

    if (_firstSelectedIndex == null) {
      _firstSelectedIndex = index;
    } else {
      setState(() => _moves++);
      final prev = _firstSelectedIndex!;
      final matched = _shuffledEmojis[prev] == _shuffledEmojis[index];

      if (matched) {
        setState(() {
          _isMatched[prev] = true;
          _isMatched[index] = true;
        });
      } else {
        Future.delayed(const Duration(milliseconds: 600), () {
          setState(() {
            _isFlipped[prev] = false;
            _isFlipped[index] = false;
          });
        });
      }
      _firstSelectedIndex = null;
    }
  }

  int _matchedPairs() => _isMatched.where((b) => b).length ~/ 2;

  (int columns, int rows) _calculateGridDimensions(int total) {
    final root = sqrt(total).floor();
    for (var cols = root; cols >= 1; cols--) {
      if (total % cols == 0) {
        return (cols, total ~/ cols);
      }
    }
    return (1, total);
  }
}

class MemoryCard extends StatelessWidget {
  final String emoji;
  final bool flipped;
  final VoidCallback onTap;

  const MemoryCard({
    required this.emoji,
    required this.flipped,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = constraints.biggest;
          final fontSize = size.shortestSide * 0.5; // Emoji fills ~50% of tile

          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: flipped ? Colors.white : const Color(0xFFFF8A65), // coral
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(71, 0, 0, 0),
                  blurRadius: 4,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                flipped ? emoji : '',
                style: TextStyle(fontSize: fontSize),
              ),
            ),
          );
        },
      ),
    );
  }
}
