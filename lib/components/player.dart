import 'package:flame_3d/core.dart';
import 'package:flame_3d_extras/model/model_component.dart';
import 'package:flame_3d_extras/parser/model_parser.dart';

class Player extends ModelComponent {
  Player({
    required super.position,
    required super.model,
  }) {
    final weapons = {
      '1H_Crossbow',
      '2H_Crossbow',
      'Knife',
      'Throwable',
      'Knife_Offhand',
    };
    for (final weapon in weapons) {
      hideNodeByName(weapon);
    }

    playAnimationByName('Idle');
  }

  static Future<Player> create() async {
    return Player(
      position: Vector3.zero(),
      model: await ModelParser.parse('objects/rogue.glb'),
    );
  }
}
