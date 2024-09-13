import 'dart:async';

import 'package:collect_the_donut/audio.dart';
import 'package:collect_the_donut/components/player.dart';
import 'package:collect_the_donut/menu/main_menu.dart';
import 'package:collect_the_donut/menu/menu.dart';
import 'package:collect_the_donut/menu/pause_menu.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart' show FlameGame;
import 'package:flame_3d/camera.dart';
import 'package:flame_3d/components.dart';
import 'package:flame_3d/game.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class CollectTheDonutGame extends FlameGame<CollectTheDonutWorld>
    with HasKeyboardHandlerComponents {
  Menu? menu;

  bool get isPaused => menu is PauseMenu;

  CollectTheDonutGame()
      : super(
          world: CollectTheDonutWorld(),
          camera: CameraComponent3D(),
        );

  @override
  FutureOr<void> onLoad() async {
    await Audio.init();
    _updateMenu(MainMenu());
  }

  Future<void> initGame() async {
    _removeMenu();
    await world.initGame();
    resume();
  }

  void restartGame() {
    world.resetGame();
    _updateMenu(MainMenu());
  }

  @override
  CameraComponent3D get camera => super.camera as CameraComponent3D;

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (keysPressed.contains(LogicalKeyboardKey.escape)) {
      if (isPaused) {
        resume();
      } else {
        pause();
      }
    }
    return super.onKeyEvent(event, keysPressed);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (isPaused) {
      return;
    }
  }

  void _updateMenu(Menu menu) {
    if (this.menu != menu) {
      _removeMenu();
      camera.viewport.add(this.menu = menu);
    }
  }

  void _removeMenu() {
    final currentMenu = menu;
    if (currentMenu != null) {
      camera.viewport.remove(currentMenu);
      menu = null;
    }
  }

  void pause() {
    _updateMenu(PauseMenu());
  }

  void resume() {
    _removeMenu();
  }
}

class CollectTheDonutWorld extends World3D with TapCallbacks {
  static const maxEnemies = 32;
  double spawnRate = 0.064 * 5;

  CollectTheDonutWorld()
      : super(
          clearColor: const Color(0xFF000000),
        );

  @override
  CollectTheDonutGame get game => findParent<CollectTheDonutGame>()!;

  late Player player;

  FutureOr<void> initGame() async {
    await addAll([
      player = await Player.create(
        position: Vector3(0, 0, -100),
      ),
      LightComponent.ambient(
        intensity: 0.75,
      ),
      LightComponent.point(
        position: Vector3.zero(),
        intensity: 20.0,
      ),
      // await Donut.donut(
      //   position: Vector3.zero(),
      // ),
    ]);
  }

  void resetGame() {
    removeWhere((e) => true);
    spawnRate = 0.1;
  }
}
