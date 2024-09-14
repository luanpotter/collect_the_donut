import 'dart:async';

import 'package:collect_the_donut/components/donut.dart';
import 'package:collect_the_donut/components/floor.dart';
import 'package:collect_the_donut/components/player.dart';
import 'package:collect_the_donut/components/skeleton.dart';
import 'package:collect_the_donut/components/wall.dart';
import 'package:collect_the_donut/components/wisp.dart';
import 'package:collect_the_donut/constants.dart';
import 'package:collect_the_donut/menu/end_game_menu.dart';
import 'package:collect_the_donut/menu/main_menu.dart';
import 'package:collect_the_donut/menu/menu.dart';
import 'package:collect_the_donut/menu/pause_menu.dart';
import 'package:collect_the_donut/third_person_camera.dart';
import 'package:collect_the_donut/utils.dart';
import 'package:flame/components.dart' as flame;
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

  bool get isPaused => menu != null;

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

  void gameOver() {
    _updateMenu(EndGameMenu());
  }

  void pause() {
    _updateMenu(PauseMenu());
  }

  void resume() {
    _removeMenu();
  }

  void collectDonut(Donut donut) {
    world.spawnDonut();
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
  double skeletonSpawnRate = 0.1;

  FutureOr<void> initGame() async {
    await addAll([
      player,

      // lights and wisps
      LightComponent.ambient(
        intensity: 600.0,
      ),
      ...List.generate(3, (_) => Wisp()),

      // floor and walls
      Floor(
        size: Vector2.all(2 * worldSize),
      ),
      Wall(
        start: Vector3(worldSize, 0, -worldSize),
        end: Vector3(worldSize, 0, worldSize),
      ),
      Wall(
        start: Vector3(-worldSize, 0, worldSize),
        end: Vector3(worldSize, 0, worldSize),
      ),

      flame.TimerComponent(
        period: 1, // 1 second
        repeat: true,
        onTick: () {
          if (randomBoolean(skeletonSpawnRate)) {
            add(Skeleton());
          } else if (randomBoolean(skeletonSpawnRate)) {
            skeletonSpawnRate += 0.005;
          }
        },
      ),
    ]);

    spawnDonut();
  }

  void resetGame() {
    removeWhere((e) => true);
  }

  void spawnDonut() {
    add(Donut.random());
  }
}
