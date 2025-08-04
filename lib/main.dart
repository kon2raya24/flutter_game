import 'package:brain_booster_flutter/screens/game_selector.dart';
import 'package:brain_booster_flutter/screens/landing_screen.dart';
import 'package:flutter/material.dart';
import 'screens/memory_game.dart';
import 'screens/shape_tap_game.dart';
import 'screens/draw_board.dart';
import 'services/ad_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AdService.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Kids Creative Games',
        theme: ThemeData(primarySwatch: Colors.teal),
        routes: {
          '/': (context) => LandingScreen(),
          '/selector': (context) => GameSelector(),
          '/memory': (context) => const MemoryGame(),
          '/shapeTap': (context) => ShapeTapGame(),
          '/draw': (context) => DrawBoard(),
        },
      ),
    );
  }
}
