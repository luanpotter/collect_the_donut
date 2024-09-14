import 'package:collect_the_donut/loader.dart';
import 'package:flame_3d/core.dart';
import 'package:flame_3d_extras/model/model_component.dart';

class Donut extends ModelComponent {
  Donut({
    required Vector3 position,
  }) : super(
          position: position,
          model: Loader.models.donut,
        ) {
    // transform.position = Vector3(0, 0, 0);
  }
}
