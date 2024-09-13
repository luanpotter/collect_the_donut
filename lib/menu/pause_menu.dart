import 'package:collect_the_donut/menu/menu.dart';
import 'package:collect_the_donut/menu/menu_item.dart';
import 'package:collect_the_donut/styles.dart';
import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

class PauseMenu extends Menu {
  static final _overlay = Paint()..color = const Color(0xAF000000);

  @override
  Future<void> onLoad() async {
    await add(
      MenuItem(
        textRenderer: Styles.textBig,
        text: '- continue -',
        positionProvider: (gameSize) => gameSize / 2,
        anchor: Anchor.center,
        onTap: game.resume,
      ),
    );
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(game.canvasSize.toRect(), _overlay);
  }
}
