import 'dart:math';
import 'dart:ui';

import 'package:collect_the_donut/components/player.dart';
import 'package:flame_3d/core.dart';
import 'package:flame_3d_extras/model/model_component.dart';

final _r = Random();

bool randomBoolean(double odds) {
  return _r.nextDouble() < odds;
}

double randomDouble(double min, double max) {
  return min + _r.nextDouble() * (max - min);
}

int randomInt(int min, int max) {
  return min + _r.nextInt(max - min);
}

Color randomColor() {
  return Color.fromARGB(
    255,
    randomInt(0, 256),
    randomInt(0, 256),
    randomInt(0, 256),
  );
}

extension Vector3Extensions on Vector3 {
  /// Changes the [length] of the vector to the length provided, without
  /// changing direction.
  ///
  /// If you try to scale the zero (empty) vector, it will remain unchanged, and
  /// no error will be thrown.
  void scaleTo(double newLength) {
    final l = length;
    if (l != 0) {
      scale(newLength.abs() / l);
    }
  }

  Vector3 scaledTo(double newLength) {
    return clone()..scaleTo(newLength);
  }
}

extension ModelComponentCollides on ModelComponent {
  bool collidesWith(Player player, { required double radius }) {
    if (!player.aabb.intersectsWithAabb3(aabb)) {
      return false;
    }

    final v1 = player.position.xz;
    final v2 = position.xz;
    return (v1 - v2).length < radius;
  }
}
