import 'dart:math';

import 'package:collect_the_donut/collect_the_donut.dart';
import 'package:collect_the_donut/constants.dart';
import 'package:collect_the_donut/loader.dart';
import 'package:collect_the_donut/utils.dart';
import 'package:flame/components.dart' as flame;
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

    final didRotate = _rotate(dt);
    if (didRotate) {
      playAnimationByName('Idle_B', resetClock: false);
    } else {
      playAnimationByName('Walking_C', resetClock: false);
      _move(dt);
    }
  }

  bool _rotate(double dt) {
    final lookAt = _target - position;
    final targetAngle = atan2(lookAt.x, lookAt.z);
    final angleDiff = targetAngle - _lookAngle;
    if (angleDiff == 0.0) {
      return false;
    }

    final rotationAngle = _rotationSpeed * dt;
    if (angleDiff.abs() < rotationAngle) {
      lookAngle = targetAngle;
    } else {
      lookAngle += angleDiff.sign * rotationAngle;
    }
    return true;
  }

  void _move(double dt) {
    final lookAt = _target - position;

    final distance = lookAt.length;
    if (distance == 0) {
      _updateTarget();
      return;
    }
    final walkDistance = _linearSpeed * dt;
    if (distance < walkDistance) {
      position.setFrom(_target);
      _enforceAngle();
    } else {
      position += lookAt.scaledTo(walkDistance);
      _enforceAngle();
    }
  }

  void _enforceAngle() {
    final lookAt = _target - position;
    final targetAngle = atan2(lookAt.x, lookAt.z);
    lookAngle = targetAngle;
  }

  void _updateTarget() {
    _target.setValues(
      randomDouble(_worldMin.x, _worldMax.x),
      0.0,
      randomDouble(_worldMin.z, _worldMax.z),
    );
  }
}

const double _rotationSpeed = 1.2;
const double _linearSpeed = 1.05;

const double _m = 0.75;
final Vector3 _worldMin = Vector3(-worldSize + _m, 0, -worldSize + _m);
final Vector3 _worldMax = Vector3(worldSize - _m, 0, worldSize - _m);
