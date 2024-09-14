import 'package:collect_the_donut/loader.dart';
import 'package:flame/components.dart' as flame;
import 'package:flame_3d/core.dart';
import 'package:flame_3d_extras/model/model_component.dart';

class Floor extends flame.Component {
  Floor({
    required Vector2 size,
  }) {
    final start = Vector3(
      -size.x / 2 + _floorSegmentSize / 2,
      -_floorHeight,
      -size.y / 2 + _floorSegmentSize / 2,
    );

    for (var x = 0; x < size.x / _floorSegmentSize; x++) {
      for (var y = 0; y < size.y / _floorSegmentSize; y++) {
        final position = start.clone()
          ..x += x * _floorSegmentSize
          ..z += y * _floorSegmentSize;
        add(_FloorSection()..position.setFrom(position));
      }
    }
  }
}

class _FloorSection extends ModelComponent {
  _FloorSection()
      : super(
          position: Vector3.zero(),
          model: Loader.models.floor,
        ) {
    transform.position.setValues(0, -0.5, 0);
  }
}

const double _floorHeight = 0.5;
const double _floorSegmentSize = 4.0;
