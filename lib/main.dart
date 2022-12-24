import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:skattergirl/world/ground.dart';

import 'actors/sora.dart';

void main() {
  runApp(GameWidget(game: SkateGame()));
}

class SkateGame extends FlameGame with HasCollisionDetection, TapDetector {
  Sora sora = Sora();
  double gravity = 2.8;
  double pushSpeed = 100;
  final double jumpForce = 10;
  Vector2 velocity = Vector2(0, 0);
  late TiledComponent homeMap;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    homeMap = await TiledComponent.load('map.tmx', Vector2.all(32));
    add(homeMap);

    double mapWidth = 32.0 * homeMap.tileMap.map.width;
    double mapHeight = 32.0 * homeMap.tileMap.map.height;
    final obstacleGroup = homeMap.tileMap.getLayer<ObjectGroup>('ground');

    for (final obj in obstacleGroup!.objects) {
      add(Ground(
          position: Vector2(obj.x, obj.y),
          size: Vector2(obj.width, obj.height)));
    }

    camera.viewport = FixedResolutionViewport(Vector2(mapWidth, mapHeight));

    sora
      ..sprite = await loadSprite('girl.png')
      ..size = Vector2.all(100)
      ..position = Vector2(100, 30);
    add(sora);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!sora.onGround) {
      velocity.y += gravity;
    }
    sora.position += velocity * dt;
  }

  @override
  void onTapDown(TapDownInfo info) {
    super.onTapDown(info);
    if (sora.onGround) {
      if (info.eventPosition.game.x < 100) {
        if (sora.facingRight) {
          sora.flipHorizontallyAroundCenter();
          sora.facingRight = false;
        }
        sora.x -= 5;
        velocity.x -= pushSpeed;
      } else if (info.eventPosition.game.x > size[0] - 100) {
        if (!sora.facingRight) {
          sora.flipHorizontallyAroundCenter();
          sora.facingRight = true;
        }
        sora.x += 5;
        velocity.x += pushSpeed;
      }
      if (info.eventPosition.game.y < 100) {
        print('move up');
        sora.y -= 10;
        velocity.y = -jumpForce;
      }
    }
  }
}
