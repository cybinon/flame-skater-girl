import 'dart:developer';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:skattergirl/main.dart';

import '../world/ground.dart';

class Sora extends SpriteComponent
    with CollisionCallbacks, HasGameRef<SkateGame> {
  Sora() : super() {
    debugMode = true;
  }
  bool onGround = false;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox());
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, other) {
    super.onCollision(intersectionPoints, other);
    if (other is Ground) {
      gameRef.velocity.y = 0;
      inspect("hit ground");
      onGround = true;
    }
  }
}
