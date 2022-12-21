import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Ground extends PositionComponent {
  Ground({
    required Vector2 position,
    required Vector2 size,
  }) : super(size: size, position: position) {
    debugMode = true;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox());
  }
}
