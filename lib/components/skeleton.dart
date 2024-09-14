import 'dart:math';

import 'package:collect_the_donut/collect_the_donut.dart';
import 'package:collect_the_donut/components/player.dart';
import 'package:collect_the_donut/constants.dart';
import 'package:collect_the_donut/loader.dart';
import 'package:collect_the_donut/utils.dart';
import 'package:flame/components.dart' as flame;
import 'package:flame/geometry.dart';
import 'package:flame_3d/core.dart';
import 'package:flame_3d_extras/model/model_component.dart';

class Skeleton extends ModelComponent
    with flame.HasGameRef<CollectTheDonutGame> {
  Skeleton()
      : super(
          model: Loader.models.skeleton,
        ) {
    _updateTarget();
    position.setFrom(_target);
  }

  final Vector3 _target = Vector3.zero();
  double _idleTimer = 0.0;
  double _deathTimer = 0.0;

  double _lookAngle = 0.0;
  double get lookAngle => _lookAngle;
  set lookAngle(double value) {
    _lookAngle = value;
    transform.rotation.setAxisAngle(up, value);
  }

  @override
  void update(double dt) {
    if (game.isPaused) {
      return;
    }

    super.update(dt);

    if (_deathTimer > 0) {
      _deathTimer -= dt;
      if (_deathTimer <= 0) {
        _deathTimer = -1;
        game.world.remove(this);
      }
      return;
    }

    final player = game.world.player;
    final isAttacking = player.action == PlayerAction.attack;
    if (collidesWith(player, radius: isAttacking ? 1.05 : 0.75)) {
      if (isAttacking) {
        die();
      } else {
        player.die();
      }
      return;
    }

    if (_idleTimer > 0) {
      _idleTimer -= dt;
      if (_idleTimer <= 0) {
        _idleTimer = 0;
        _updateTarget();
      }
      playAnimationByName('Idle_B', resetClock: false);
      return;
    } else {
      playAnimationByName('Walking_C', resetClock: false);
    }

    _rotate(dt);
    _move(dt);
  }

  void _rotate(double dt) {
    final lookAt = _target - position;
    final targetAngle = atan2(lookAt.x, lookAt.z);
    final angleDiff = _normalizeAngle(targetAngle - _lookAngle);

    final rotationAngle = _rotationSpeed * dt;
    if (angleDiff.abs() < rotationAngle) {
      lookAngle = targetAngle;
    } else {
      lookAngle += angleDiff.sign * rotationAngle;
    }
  }

  void _move(double dt) {
    final moveDirection = Vector3(
      sin(_lookAngle),
      0,
      cos(_lookAngle),
    );

    final walkDistance = _linearSpeed * dt;
    if ((_target - position).length <= walkDistance) {
      position.setFrom(_target);
      _idleTimer = randomDouble(1, 3);
    } else {
      position += moveDirection.scaled(walkDistance);
      position.clamp(_worldMin, _worldMax);
    }
  }

  void _updateTarget() {
    _target.setValues(
      randomDouble(_worldMin.x, _worldMax.x),
      0.0,
      randomDouble(_worldMin.z, _worldMax.z),
    );
  }

  // normalizes to [-pi, pi]
  double _normalizeAngle(double angle) {
    return (angle + pi) % tau - pi;
  }

  void die() {
    if (_deathTimer != 0) {
      return;
    }
    _deathTimer = 0.8; // death animation duration
    playAnimationByName('Death_A');
  }
}

const double _rotationSpeed = 1.2;
const double _linearSpeed = 1.05;

const double _m = 0.75;
final Vector3 _worldMin = Vector3(-worldSize + _m, 0, -worldSize + _m);
final Vector3 _worldMax = Vector3(worldSize - _m, 0, worldSize - _m);
