import 'dart:ui';

import 'package:collect_the_donut/collect_the_donut.dart';
import 'package:collect_the_donut/styles.dart';
import 'package:flame/components.dart';

class Hud extends Component with HasGameRef<CollectTheDonutGame> {
  @override
  void render(Canvas canvas) {
    super.render(canvas);

    Styles.textHuge.render(
      canvas,
      game.score.toString().padLeft(2, '0'),
      Vector2(
        game.size.x - _margin,
        _margin,
      ),
      anchor: Anchor.topRight,
    );
  }
}

const double _margin = 12.0;
