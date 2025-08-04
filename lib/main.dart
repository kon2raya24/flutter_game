import 'package:brain_booster_flutter/screens/landing_screen.dart';
import 'package:flutter/material.dart';
import 'screens/game_selector.dart';
import 'screens/memory_game.dart';
import 'screens/shape_tap_game.dart';
import 'screens/draw_board.dart';
import 'services/ad_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AdService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        title: 'Brain Booster',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        routes: {
          '/': (context) => const ExitWrapper(child: LandingScreen()),
          '/selector': (context) => const BackToLanding(child: GameSelector()),
          '/memory': (context) => const MemoryGame(),
          '/shapeTap': (context) => const ShapeTapGame(),
          '/draw': (context) => const DrawBoard(),
        },
      ),
    );
  }
}

class ExitWrapper extends StatelessWidget {
  final Widget child;
  const ExitWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        final shouldExit = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit Game?'),
            content: const Text('Are you sure you want to exit the app?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Exit'),
              ),
            ],
          ),
        );
        return shouldExit ?? false;
      },
      child: child,
    );
  }
}

class BackToLanding extends StatelessWidget {
  final Widget child;
  const BackToLanding({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        return false;
      },
      child: child,
    );
  }
}
