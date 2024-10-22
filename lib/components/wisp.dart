import 'dart:async';

import 'package:collect_the_donut/collect_the_donut.dart';
import 'package:collect_the_donut/constants.dart';
import 'package:collect_the_donut/utils.dart';
import 'package:flame/components.dart' show HasGameRef;
import 'package:flame_3d/components.dart';
import 'package:flame_3d/core.dart';
import 'package:flame_3d/resources.dart';
import 'package:flutter/widgets.dart';

class Wisp extends LightComponent with HasGameRef<CollectTheDonutGame> {
  late final _VisualLight _mesh;
  final Vector3 _start = Vector3.zero();
  final Vector3 _target = Vector3.zero();
  double pathTimer = 0.0;
  double pathDuration = 0.0;

  Wisp()
      : super.point(
          color: randomColor(),
          intensity: 20.0,
        );

  @override
  FutureOr<void> onLoad() async {
    await add(
      _mesh = _VisualLight(color: source.color),
    );
    _randomTarget();
    move(_target);
    await super.onLoad();
  }

  @override
  void update(double dt) {
    if (game.isPaused) {
      return;
    }

    super.update(dt);

    pathTimer += dt;
    if (pathTimer >= pathDuration) {
      _randomTarget();
      pathTimer = 0.0;
      pathDuration = randomDouble(2, 2 + (_target - _start).length / _speed);
    }

    final t = pathTimer / pathDuration;
    const curve = Curves.easeInOutCubic;
    move(Vector3Utils.lerp(_start, _target, curve.transform(t)));
  }

  void move(Vector3 position) {
    this.position.setFrom(position);
    _mesh.position.setFrom(position);
  }

  void _randomTarget() {
    _start.setFrom(position);
    _target.setValues(
      randomDouble(-worldSize, worldSize),
      randomDouble(0.2, 2.5),
      randomDouble(-worldSize, worldSize),
    );
  }
}

class _VisualLight extends MeshComponent with HasGameRef<CollectTheDonutGame> {
  _VisualLight({
    required Color color,
  }) : super(
          mesh: SphereMesh(
            radius: 0.05,
            material: SpatialMaterial(
              albedoTexture: ColorTexture(color),
              albedoColor: color,
            ),
          ),
        );
}

const double _speed = 8.0;