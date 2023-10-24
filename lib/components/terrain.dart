import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:gravityguy/pages/game.dart';

class Terrain extends SpriteComponent
    with TapCallbacks, HasGameRef<GravityGuyGame>, CollisionCallbacks {
  double xValue = 0;
  double yValue = 0;

  Terrain(this.xValue, this.yValue);

  late double vx;
  late bool changePosition = false;

  @override
  void onLoad() async {
    add(RectangleHitbox(isSolid: true, collisionType: CollisionType.active));
    vx = 200;
    sprite = await gameRef.loadSprite('stone.png');
    position = Vector2(xValue, yValue);
    size = Vector2(64.0, 64.0);
    anchor = Anchor.center;

    position.y = yValue;
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= vx * dt;

    if (position.x < -100) {
      removeFromParent();
    }
  }
}
