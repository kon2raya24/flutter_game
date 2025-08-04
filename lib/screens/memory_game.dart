import 'package:brain_booster_flutter/widgets/memory_card.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:lottie/lottie.dart';

class MemoryGame extends StatefulWidget {
  const MemoryGame({super.key});

  @override
  State<MemoryGame> createState() => _MemoryGameState();
}

class _MemoryGameState extends State<MemoryGame> with TickerProviderStateMixin {
  final List<String> _emojis = [
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
    '🐧',
    '🐦',
    '🐤',
    '🦄',
  ];

  List<String> _shuffledEmojis = [];
  List<bool> _isFlipped = [];
  List<bool> _isMatched = [];
  int? _selectedIndex;
  bool _canTap = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showLevelDialog();
    });
  }

  void _generateBoard(int pairCount) {
    final selected = _emojis.take(pairCount).toList();
    _shuffledEmojis = [...selected, ...selected]..shuffle();
    _isFlipped = List.filled(_shuffledEmojis.length, false);
    _isMatched = List.filled(_shuffledEmojis.length, false);
    setState(() {
      _selectedIndex = null;
    });
  }

  void _showLevelDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        final customController = TextEditingController();
        return AlertDialog(
          title: const Text("🧠 Select Difficulty"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _generateBoard(4);
                  },
                  child: const Text("Easy (4 Pairs)"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _generateBoard(8);
                  },
                  child: const Text("Medium (8 Pairs)"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _generateBoard(12);
                  },
                  child: const Text("Hard (12 Pairs)"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _generateBoard(20);
                  },
                  child: const Text("Extreme (20 Pairs)"),
                ),
                const Divider(),
                TextField(
                  controller: customController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Custom Pairs (max 20)",
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    int? custom = int.tryParse(customController.text);
                    if (custom != null && custom > 0 && custom <= 20) {
                      Navigator.pop(context);
                      _generateBoard(custom);
                    } else {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("Invalid Input"),
                          content: const Text(
                            "Please enter a number from 1 to 20.",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("OK"),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: const Text("Start Custom Game"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onCardTap(int index) {
    if (!_canTap || _isFlipped[index] || _isMatched[index]) return;

    setState(() => _isFlipped[index] = true);

    if (_selectedIndex == null) {
      _selectedIndex = index;
    } else {
      _canTap = false;
      final prevIndex = _selectedIndex!;
      if (_shuffledEmojis[prevIndex] == _shuffledEmojis[index]) {
        Future.delayed(const Duration(milliseconds: 500), () {
          setState(() {
            _isMatched[prevIndex] = true;
            _isMatched[index] = true;
            _selectedIndex = null;
            _canTap = true;
          });
          _checkWin();
        });
      } else {
        Future.delayed(const Duration(milliseconds: 800), () {
          setState(() {
            _isFlipped[prevIndex] = false;
            _isFlipped[index] = false;
            _selectedIndex = null;
            _canTap = true;
          });
        });
      }
    }
  }

  void _checkWin() {
    if (_isMatched.every((m) => m)) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: const Text("🎉 You Win!"),
          content: const Text("Great job! Want to play again?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showLevelDialog();
              },
              child: const Text("Play Again"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = sqrt(_shuffledEmojis.length).round();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Memory Match"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _showLevelDialog,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background animation
          Positioned.fill(
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.2,
                child: Lottie.asset(
                  'assets/animations/stars.json',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Game grid
          _shuffledEmojis.isEmpty
              ? const Center(
                  child: Text(
                    "Please select a level",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final totalCards = _shuffledEmojis.length;
                      int columns;
                      int rows;

                      // Dynamically decide columns and rows
                      if (totalCards == 8) {
                        columns = 4;
                        rows = 2;
                      } else if (totalCards == 12) {
                        columns = 4;
                        rows = 3;
                      } else if (totalCards == 16) {
                        columns = 4;
                        rows = 4;
                      } else {
                        columns = (sqrt(totalCards)).ceil();
                        rows = (totalCards / columns).ceil();
                      }

                      const spacing = 8.0;
                      final width =
                          (constraints.maxWidth - (columns - 1) * spacing) /
                          columns;
                      final height =
                          (constraints.maxHeight - (rows - 1) * spacing) / rows;
                      final aspectRatio = width / height;

                      return GridView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: totalCards,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          crossAxisSpacing: spacing,
                          mainAxisSpacing: spacing,
                          childAspectRatio: aspectRatio,
                        ),
                        itemBuilder: (context, index) {
                          final emoji = _shuffledEmojis[index];
                          final flipped = _isFlipped[index];
                          return MemoryCard(
                            emoji: emoji,
                            flipped: flipped,
                            onTap: () => _onCardTap(index),
                          );
                        },
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
