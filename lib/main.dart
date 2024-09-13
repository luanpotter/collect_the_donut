import 'package:collect_the_donut/collect_the_donut.dart';
import 'package:flame/game.dart' show GameWidget;
import 'package:flutter/widgets.dart';

void main() async {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with WidgetsBindingObserver {
  final game = CollectTheDonutGame();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      return;
    }

    if (!game.isPaused) {
      game.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GameWidget(game: game);
  }
}
