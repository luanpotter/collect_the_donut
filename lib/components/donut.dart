import 'package:collect_the_donut/collect_the_donut.dart';
import 'package:collect_the_donut/constants.dart';
import 'package:collect_the_donut/loader.dart';
import 'package:collect_the_donut/utils.dart';
import 'package:flame/components.dart' as flame;
import 'package:flame_3d/core.dart';
import 'package:flame_3d_extras/model/model_component.dart';

class Donut extends ModelComponent with flame.HasGameRef<CollectTheDonutGame> {
  Donut({
    required Vector3 position,
  }) : super(
          position: position,
          model: Loader.models.donut,
        );

  @override
  void update(double dt) {
    if (game.isPaused) {
      return;
    }

    super.update(dt);
    if (collidesWith(game.world.player, radius: 0.75)) {
      game.collectDonut(this);
      game.world.remove(this);
    }
  }

  factory Donut.random() {
    const margin = 1.2;
    const min = -worldSize + margin;
    const max = worldSize - margin;
    return Donut(
      position: Vector3(
        randomDouble(min, max),
        0.5,
        randomDouble(min, max),
      ),
    );
  }
}
