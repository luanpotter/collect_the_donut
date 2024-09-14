import 'dart:math';

import 'package:collect_the_donut/constants.dart';
import 'package:collect_the_donut/loader.dart';
import 'package:collect_the_donut/utils.dart';
import 'package:flame/components.dart' as flame;
import 'package:flame_3d/core.dart';
import 'package:flame_3d_extras/model/model_component.dart';

class Wall extends flame.Component {
  Wall({
    required Vector3 start,
    required Vector3 end,
  }) {
    final direction = end - start;
    final position = start + direction.scaledTo(_wallSegmentSize / 2);
    var totalDistance = direction.length;

    while (totalDistance >= _wallSegmentSize) {
      // rotate the wall to align with the start-end line
      final rotation = Quaternion.axisAngle(
        up,
        atan2(start.z - end.z, start.x - end.x),
      );

      add(
        _WallSection(
          wallIndex: randomInt(0, Loader.models.walls.length),
          position: position,
          rotation: rotation,
        ),
      );

      position.add(direction.scaledTo(_wallSegmentSize));
      totalDistance -= _wallSegmentSize;
    }
  }
}

class _WallSection extends ModelComponent {
  _WallSection({
    required int wallIndex,
    required Vector3 position,
    required Quaternion rotation,
  }) : super(
          position: position,
          rotation: rotation,
          model: Loader.models.walls[wallIndex],
        );
}

const double _wallSegmentSize = 4.0;
