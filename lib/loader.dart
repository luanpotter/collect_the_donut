import 'package:flame_3d_extras/model/model.dart';
import 'package:flame_3d_extras/parser/model_parser.dart';

class Loader {
  Loader._();

  static late Models models;

  static Future<void> init() async {
    models = await Models.load();
  }
}

class Models {
  final Model rogue;

  Models({
    required this.rogue,
  });

  static Future<Models> load() async {
    return Models(
      rogue: await ModelParser.parse('objects/rogue.glb'),
    );
  }
}
