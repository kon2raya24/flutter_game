import 'package:flutter/material.dart';

class DrawBoard extends StatefulWidget {
  const DrawBoard({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DrawBoardState createState() => _DrawBoardState();
}

class _DrawBoardState extends State<DrawBoard> {
  List<Offset?> points = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Drawing Board")),
      body: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            points.add(details.localPosition);
          });
        },
        onPanEnd: (_) => points.add(null),
        child: CustomPaint(
          painter: DrawPainter(points),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class DrawPainter extends CustomPainter {
  final List<Offset?> points;
  DrawPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 4.0;
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}