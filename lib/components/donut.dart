import 'package:collect_the_donut/collect_the_donut.dart';
import 'package:collect_the_donut/components/player.dart';
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
    if (_intersects(game.world.player)) {
      game.collectDonut(this);
      game.world.remove(this);
    }
  }

  bool _intersects(Player player) {
    if (!player.aabb.intersectsWithAabb3(aabb)) {
      return false;
    }

    final v1 = player.position.xz;
    final v2 = position.xz;
    return (v1 - v2).length < 0.75;
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
