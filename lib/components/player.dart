import 'dart:math';

import 'package:collect_the_donut/collect_the_donut.dart';
import 'package:collect_the_donut/constants.dart';
import 'package:collect_the_donut/input_utils.dart';
import 'package:collect_the_donut/loader.dart';
import 'package:flame/components.dart' as flame;
import 'package:flame/events.dart';
import 'package:flame/geometry.dart';
import 'package:flame_3d/core.dart';
import 'package:flame_3d_extras/model/model_component.dart';
import 'package:flutter/services.dart';

class Player extends ModelComponent
    with
        flame.HasGameRef<CollectTheDonutGame>,
        flame.KeyboardHandler,
        TapCallbacks {
  Player()
      : super(
          position: Vector3.zero(),
          model: Loader.models.rogue,
        ) {
    weapon = PlayerWeapon.knife;
  }

  PlayerAction? _action;
  double _actionTimer = 0.0;
  PlayerAction? get action => _action;
  set action(PlayerAction? value) {
    if (_actionTimer != 0.0) {
      return;
    }

    _action = value;
    _actionTimer = value?.timer ?? 0.0;
    stopAnimation();
  }

  late PlayerWeapon _weapon;
  PlayerWeapon get weapon => _weapon;
  set weapon(PlayerWeapon value) {
    _weapon = value;
    _updateWeapon();
  }

  bool _isRunning = false;

  void _updateWeapon() {
    for (final hide in PlayerWeapon.values) {
      hideNodeByName(hide.nodeName);
    }
    hideNodeByName(weapon.nodeName, hidden: false);
  }

  double _lookAngle = 0.0;
  double get lookAngle => _lookAngle;
  set lookAngle(double value) {
    _lookAngle = value % tau;
    transform.rotation.setAxisAngle(up, value);
  }

  Vector3 get lookAt => Vector3(sin(_lookAngle), 0.0, cos(_lookAngle));

  final Vector2 _input = Vector2.zero();

  @override
  void update(double dt) {
    if (game.isPaused) {
      return;
    }

    super.update(dt);

    if (_actionTimer != 0.0) {
      _actionTimer -= dt;
      if (_actionTimer <= 0.0) {
        _actionTimer = 0.0;
        _action = null;
      }
    }

    final isMoving = _handleMovement(dt);
    _updateAnimation(isMoving: isMoving);
  }

  bool _handleMovement(double dt) {
    if (_actionTimer != 0.0) {
      return false;
    }

    lookAngle += -_input.x * _rotationSpeed * dt;

    final speed = _isRunning ? _runningSpeed : _walkingSpeed;
    final movement = lookAt.scaled(-_input.y * speed * dt);

    position.add(movement);
    position.clamp(_worldMin, _worldMax);

    return movement.length2 > 0.0;
  }

  void _updateAnimation({required bool isMoving}) {
    final action = _action;
    if (action != null) {
      switch (action) {
        case PlayerAction.attack:
          playAnimationByIdx(0, resetClock: false);
      }
    } else if (isMoving && _isRunning) {
      playAnimationByName('Running_A', resetClock: false);
    } else if (isMoving) {
      playAnimationByName('Walking_C', resetClock: false);
    } else {
      playAnimationByName('Idle', resetClock: false);
    }
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    _isRunning = keysPressed.contains(LogicalKeyboardKey.shiftLeft);
    return readArrowLikeKeysIntoVector2(event, keysPressed, _input);
  }

  @override
  bool containsLocalPoint(flame.Vector2 point) => true;

  @override
  void onTapDown(_) {
    action = PlayerAction.attack;
  }
}

enum PlayerAction {
  attack(timer: 1.0666667222976685),
  ;

  final double timer;

  const PlayerAction({required this.timer});
}

enum PlayerWeapon {
  oneHandedCrossbow('1H_Crossbow'),
  twoHandedCrossbow('2H_Crossbow'),
  knife('Knife'),
  throwable('Throwable'),
  offhandKnife('Knife_Offhand'),
  ;

  final String nodeName;

  const PlayerWeapon(this.nodeName);
}

const double _rotationSpeed = 3.0;
const double _walkingSpeed = 1.85;
const double _runningSpeed = 4.5;

const double _m = 0.75;
final Vector3 _worldMin = Vector3(-worldSize + _m, 0, -worldSize + _m);
final Vector3 _worldMax = Vector3(worldSize - _m, 0, worldSize - _m);
