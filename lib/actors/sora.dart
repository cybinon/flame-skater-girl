import 'dart:developer';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:skattergirl/main.dart';

import '../world/ground.dart';

class Sora extends SpriteComponent
    with CollisionCallbacks, HasGameRef<SkateGame> {
  Sora() : super() {
    debugMode = true;
    anchor = Anchor.bottomCenter;
  }
  bool onGround = false;
  bool facingRight = true;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox());
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, other) {
    super.onCollision(intersectionPoints, other);
    if (other is Ground) {
      if (gameRef.velocity.y > 0) {
        if (intersectionPoints.length == 2) {
          var x1 = intersectionPoints.first[0];
          var x2 = intersectionPoints.last[0];
          if ((x1 - x2).abs() < 2) {
            // hit the side, so send down with gravity
            gameRef.velocity.y = 100;
          } else {
            // hit the top, so stop
            gameRef.velocity.y = 0;
            onGround = true;
          }
        }
      } else if (gameRef.velocity.x != 0) {
        for (var point in intersectionPoints) {
          if (y - 5 >= point[1]) {
            print("hit on side of ground");
            gameRef.velocity.x = 0;
          }
        }
      }
    }
  }

  @override
  void onCollisionEnd(other) {
    super.onCollisionEnd(other);
    if (other is Ground) {
      onGround = false;
    }
  }
}
