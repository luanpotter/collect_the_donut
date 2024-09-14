import 'dart:math';

import 'package:collect_the_donut/collect_the_donut.dart';
import 'package:collect_the_donut/input_utils.dart';
import 'package:collect_the_donut/loader.dart';
import 'package:flame/components.dart' show HasGameRef, KeyboardHandler;
import 'package:flame/geometry.dart';
import 'package:flame_3d/core.dart';
import 'package:flame_3d_extras/model/model_component.dart';
import 'package:flutter/services.dart';

class Player extends ModelComponent
    with HasGameRef<CollectTheDonutGame>, KeyboardHandler {
  Player()
      : super(
          position: Vector3.zero(),
          model: Loader.models.rogue,
        ) {
    final weapons = {
      '1H_Crossbow',
      '2H_Crossbow',
      // 'Knife',
      'Throwable',
      'Knife_Offhand',
    };
    for (final weapon in weapons) {
      hideNodeByName(weapon);
    }

    playAnimationByName('Idle');
  }

  double _lookAngle = 0.0;
  double get lookAngle => _lookAngle;
  set lookAngle(double value) {
    _lookAngle = value % tau;
    transform.rotation.setAxisAngle(_up, value);
  }

  Vector3 get lookAt => Vector3(sin(_lookAngle), 0.0, cos(_lookAngle));

  final Vector2 _input = Vector2.zero();

  @override
  void update(double dt) {
    super.update(dt);

    lookAngle += -_input.x * _rotationSpeed * dt;

    final movement = lookAt.scaled(-_input.y * _linearSpeed * dt);
    position.add(movement);

    if (movement.length2 > 0.0) {
      playAnimationByName('Walking_C', resetClock: false);
    } else {
      playAnimationByName('Idle', resetClock: false);
    }
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    return readArrowLikeKeysIntoVector2(event, keysPressed, _input);
  }
}

const double _rotationSpeed = 3.0;
const double _linearSpeed = 2.5;
final Vector3 _up = Vector3(0, 1, 0);
