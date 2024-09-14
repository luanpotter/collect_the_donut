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
  final Model donut;
  final Model floor;
  final List<Model> walls;

  Models({
    required this.rogue,
    required this.donut,
    required this.floor,
    required this.walls,
  });

  static Future<Models> load() async {
    return Models(
      rogue: await ModelParser.parse('objects/rogue.glb'),
      donut: await ModelParser.parse('objects/donut.obj'),
      floor: await ModelParser.parse('objects/floor.gltf'),
      walls: [
        await ModelParser.parse('objects/wall_0.gltf'),
        await ModelParser.parse('objects/wall_1.gltf'),
        await ModelParser.parse('objects/wall_2.gltf'),
      ],
    );
  }
}
