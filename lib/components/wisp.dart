import 'dart:async';

import 'package:collect_the_donut/collect_the_donut.dart';
import 'package:collect_the_donut/utils.dart';
import 'package:flame/components.dart' show HasGameRef;
import 'package:flame_3d/components.dart';
import 'package:flame_3d/core.dart';
import 'package:flame_3d/resources.dart';
import 'package:flutter/widgets.dart';

class Wisp extends LightComponent with HasGameRef<CollectTheDonutGame> {
  late final _VisualLight _mesh;
  final Vector3 _target = Vector3.zero();
  double pathTimer = 0.0;
  double pathDuration = 0.0;

  Wisp({
    required super.color,
  }) : super.point();

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
      pathTimer = 0.0;
      _randomTarget();
      pathDuration = randomDouble(5, 5 + (_target - position).length);
    }

    final t = pathTimer / pathDuration;
    const curve = Curves.easeInOut;
    move(Vector3Utils.lerp(position, _target, curve.transform(t)));
  }

  void move(Vector3 position) {
    this.position.setFrom(position);
    _mesh.position.setFrom(position);
  }

  void _randomTarget() {
    _target.setValues(
      randomDouble(-16, 16),
      randomDouble(0.3, 1.5),
      randomDouble(-16, 16),
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
              albedoColor: color,
            ),
          ),
        );
}
