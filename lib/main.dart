import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:skattergirl/world/ground.dart';

import 'actors/sora.dart';

void main() {
  runApp(GameWidget(game: SkateGame()));
}

class SkateGame extends FlameGame with HasCollisionDetection {
  Sora sora = Sora();
  double gravity = 1.8;
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
      sora.position.y += velocity.y * dt;
    }
  }
}
