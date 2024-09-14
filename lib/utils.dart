import 'dart:math';

import 'package:flame_3d/core.dart';

final _r = Random();

bool randomBoolean(double odds) {
  return _r.nextDouble() < odds;
}

double randomDouble(double min, double max) {
  return min + _r.nextDouble() * (max - min);
}

int randomInt(int max) {
  return _r.nextInt(max);
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
