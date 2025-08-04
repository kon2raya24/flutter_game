import 'package:flutter/material.dart';

class ShapeTapGame extends StatelessWidget {
  const ShapeTapGame({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Shape Tap Game")),
      body: Center(child: Text("Tap the shapes!", style: TextStyle(fontSize: 24))),
    );
  }
}