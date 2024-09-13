import 'dart:async';
import 'dart:ui';

import 'package:collect_the_donut/menu/menu.dart';
import 'package:collect_the_donut/menu/menu_item.dart';
import 'package:collect_the_donut/styles.dart';
import 'package:flame/components.dart';

class MainMenu extends Menu {
  static final mainTitle =
      Styles.title.copyWith((it) => it.copyWith(fontSize: 240));

  @override
  FutureOr<void> onLoad() async {
    await add(
      MenuItem(
        textRenderer: Styles.textBig,
        text: '- start -',
        positionProvider: (gameSize) {
          return Vector2(gameSize.x / 2, gameSize.y / 3 + 272.0);
        },
        anchor: Anchor.topCenter,
        onTap: game.initGame,
      ),
    );
  }

  @override
  void render(Canvas canvas) {
    Styles.title.render(
      canvas,
      'COLLECT THE',
      Vector2(game.size.x / 2, game.size.y / 3),
      anchor: Anchor.topCenter,
    );
    mainTitle.render(
      canvas,
      'DONUT',
      Vector2(game.size.x / 2, game.size.y / 3 + 40.0),
      anchor: Anchor.topCenter,
    );
  }
}
