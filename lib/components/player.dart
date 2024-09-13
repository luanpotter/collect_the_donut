import 'package:flame_3d/core.dart';
import 'package:flame_3d_extras/model/model_component.dart';
import 'package:flame_3d_extras/parser/model_parser.dart';

class Player extends ModelComponent {
  Player({
    required super.position,
    required super.model,
  });

  static Future<Player> create({
    required Vector3 position,
  }) async {
    return Player(
      position: position,
      model: await ModelParser.parse('objects/rogue.glb'),
    );
  }
}
