import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

import 'game.dart';

class Terrain extends SpriteComponent 
  with
    TapCallbacks,
    HasGameRef<GravityGuyGame>,
    HasCollisionDetection,
    CollisionCallbacks {
  
  late double vx;
  late bool changePosition = false;

  @override
  void onLoad() async {
    vx = 200;
    sprite = await gameRef.loadSprite('stone.png');
    position = gameRef.size / 2;
    size = Vector2(64.0, 64.0);
    anchor = Anchor.center;

    position.y = 500;
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= vx * dt;

    if (position.x < 0) {
      position.x = 400;

      if(changePosition) {
        position.y = gameRef.size.y - 200;
      } else {
        position.y = 200;
      }

      changePosition = !changePosition;
    }
  }
}