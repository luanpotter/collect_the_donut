import 'dart:async';

import 'package:collect_the_donut/components/floor.dart';
import 'package:collect_the_donut/components/player.dart';
import 'package:collect_the_donut/components/wall.dart';
import 'package:collect_the_donut/components/wisp.dart';
import 'package:collect_the_donut/menu/main_menu.dart';
import 'package:collect_the_donut/menu/menu.dart';
import 'package:collect_the_donut/menu/pause_menu.dart';
import 'package:collect_the_donut/third_person_camera.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart' show FlameGame;
import 'package:flame_3d/camera.dart';
import 'package:flame_3d/components.dart';
import 'package:flame_3d/core.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class CollectTheDonutGame extends FlameGame<CollectTheDonutWorld>
    with HasKeyboardHandlerComponents {
  Menu? menu;

  bool get isPaused => menu is PauseMenu;

  CollectTheDonutGame()
      : super(
          world: CollectTheDonutWorld(),
          camera: ThirdPersonCamera(),
        );

  @override
  FutureOr<void> onLoad() async {
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
  CollectTheDonutWorld()
      : super(
          clearColor: const Color(0xFF000000),
        );

  @override
  CollectTheDonutGame get game => findParent<CollectTheDonutGame>()!;

  final Player player = Player();

  FutureOr<void> initGame() async {
    await addAll([
      player,
      Wisp(color: const Color(0xFF5522DD)),
      Wisp(color: const Color(0xFF22DD55)),
      LightComponent.ambient(
        intensity: 0.8,
      ),
      Floor(
        size: Vector2.all(32.0),
      ),

      Wall(
        start: Vector3(16, 0, -16),
        end: Vector3(16, 0, 16),
      ),
      Wall(
        start: Vector3(-16, 0, 16),
        end: Vector3(16, 0, 16),
      ),
    ]);
  }

  void resetGame() {
    removeWhere((e) => true);
  }
}
