import 'package:flutter/material.dart';

class ShapeTapGame extends StatelessWidget {
  const ShapeTapGame({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          // 1. Pick your “base” square size
          const double targetSquareSize = 80;

          // 2. How many columns do we need to cover full width?
          final int columns = (constraints.maxWidth / targetSquareSize).ceil();

          // 3. Actual tile size so that columns * tileSize == full width
          final double tileSize = constraints.maxWidth / columns;

          // 4. How many rows to cover full height?
          final int rows = (constraints.maxHeight / tileSize).ceil();

          // 5. Total tiles to build
          final int itemCount = columns * rows;

          return GridView.builder(
            // fills the entire body
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: itemCount,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              mainAxisSpacing: 0,
              crossAxisSpacing: 0,
              childAspectRatio: 1, // force each cell to be square
            ),
            itemBuilder: (context, index) {
              final color =
                  Colors.primaries[index % Colors.primaries.length].shade300;
              return GestureDetector(
                onTap: () {
                  // your tap logic here
                },
                child: Container(color: color),
              );
            },
          );
        },
      ),
    );
  }
}
