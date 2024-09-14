import 'package:collect_the_donut/collect_the_donut.dart';
import 'package:collect_the_donut/components/player.dart';
import 'package:flame/components.dart' show HasGameRef;
import 'package:flame_3d/camera.dart';
import 'package:flame_3d/core.dart';

class ThirdPersonCamera extends CameraComponent3D
    with HasGameRef<CollectTheDonutGame> {
  ThirdPersonCamera()
      : super(
          mode: CameraMode.thirdPerson,
          fovY: 75.0,
          position: Vector3(-18, 6, -18),
          up: Vector3(0.8, 1, 0.8),
          target: Vector3(0, 0, 0),
        );

  Player get player => gameRef.world.player;

  @override
  void update(double dt) {
    super.update(dt);

    final targetOffset = player.position + _positionOffset;
    final targetLookAt = player.position + player.lookAt;

    position += (targetOffset - position) * _cameraLinearSpeed * dt;
    target += (targetLookAt - target) * _cameraRotationSpeed * dt;
  }
}

final Vector3 _positionOffset = Vector3(-4, 6, -4);
const double _cameraRotationSpeed = 6.0;
const double _cameraLinearSpeed = 12.0;
