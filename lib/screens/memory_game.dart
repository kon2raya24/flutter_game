import 'package:flutter/material.dart';
import 'dart:math';

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
        TextEditingController customController = TextEditingController();
        return AlertDialog(
          title: const Text("Select Difficulty"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _generateBoard(4); // Easy
                  },
                  child: const Text("Easy (4 Pairs)"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _generateBoard(8); // Medium
                  },
                  child: const Text("Medium (8 Pairs)"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _generateBoard(12); // Hard
                  },
                  child: const Text("Hard (12 Pairs)"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _generateBoard(20); // Extreme
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
                    int? customCount = int.tryParse(customController.text);
                    if (customCount != null &&
                        customCount > 0 &&
                        customCount <= 20) {
                      Navigator.pop(context);
                      _generateBoard(customCount);
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
    if (_isMatched.every((matched) => matched)) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: const Text("🎉 You Win!"),
          content: const Text("Congratulations! Want to play again?"),
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
      appBar: AppBar(
        title: const Text("Memory Match"),
        backgroundColor: Colors.teal.shade400,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _showLevelDialog,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.tealAccent, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: _shuffledEmojis.isEmpty
            ? const Center(child: Text("Please select a level"))
            : GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemCount: _shuffledEmojis.length,
                itemBuilder: (context, index) {
                  final emoji = _shuffledEmojis[index];
                  final flipped = _isFlipped[index] || _isMatched[index];

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    decoration: BoxDecoration(
                      color: flipped
                          ? Colors.white
                          : const Color.fromARGB(255, 88, 71, 184),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.5),
                          blurRadius: 6,
                          offset: const Offset(2, 4),
                        ),
                      ],
                    ),
                    child: InkWell(
                      onTap: () => _onCardTap(index),
                      child: Center(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (child, animation) {
                            return ScaleTransition(
                              scale: animation,
                              child: child,
                            );
                          },
                          child: Text(
                            flipped ? emoji : '',
                            key: ValueKey(flipped ? emoji : '?'),
                            style: const TextStyle(fontSize: 32),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
