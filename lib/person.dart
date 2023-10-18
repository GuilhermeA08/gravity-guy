import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/sprite.dart';
import 'package:get/get.dart';
import 'package:gravityguy/terrain.dart';

import 'game.dart';
import 'game_controller.dart';
import 'gameover.dart';

class Person extends SpriteAnimationComponent
    with TapCallbacks, HasGameRef<GravityGuyGame>, CollisionCallbacks {
  double vx = 0; //m/s
  double vy = 0; //m/s
  double ax = 0;
  double ay = 300;
  bool inverterVelocidade = false;
  bool gravity = true;
  final GameController gameController = Get.put(GameController());

  int countApple = 0;
  late SpriteSheet idleSpriteSheet, invertedIdleSpriteSheet;
  late SpriteAnimation idleAnimation, invertedIdleAnimation;
  //final animation = spriteSheet.createAnimation(0, stepTime: 0.1);
  bool gameOver = false;
  @override
  Future<void> onLoad() async {
    print("onLoad person");

    add(RectangleHitbox());

    print("hitbox person adicionado");

    position = gameRef.size / 2;
    size = Vector2(100.0, 70.0);
    anchor = Anchor.center;

    debugMode = true;
    idleSpriteSheet = SpriteSheet(
      image: await gameRef.images.load('spacerun2.png'),
      srcSize: Vector2(93.5, 102.0),
    );
    invertedIdleSpriteSheet = SpriteSheet(
      image: await gameRef.images.load('invertedrun2.png'),
      srcSize: Vector2(93.5, 100.0),
    );

    idleAnimation = idleSpriteSheet.createAnimation(
        row: 0, stepTime: 0.07, from: 0, to: 8, loop: true);
    invertedIdleAnimation = invertedIdleSpriteSheet.createAnimation(
        row: 0, stepTime: 0.07, from: 0, to: 8, loop: true);

    //define a animação atual
    animation = idleAnimation;
    //add(RectangleHitbox(isSolid: true, size: Vector2(32,32),position: Vector2(200,200),collisionType: CollisionType.active));
    super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    if (other is Terrain) {
      gravity = false;

      //Se o personagem está a baixo do chão, mudar o posição do personagem para logo a baixo do chão
      if (points.first.y > other.position.y) {
        position.y = (other.position.y + other.size.y / 2 + size.y / 2) + 2;
      }

      //Se o personagem está a cima do chão, mudar o posição do personagem para logo a cima do chão

      if (points.first.y < other.position.y) {
        position.y = (other.position.y - other.size.y / 2 - size.y / 2) - 2;
      }

      // Se o personagem colidir com o chão pela esquerda a gravidade continua sendo true
      // if (points.first.x < other.position.x) {
      //   gravity = true;
      // }
    }
    super.onCollision(points, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);

    if (other is Terrain) {
      gravity = true;
    }
  }

  void jump() {
    if (!gravity) {
      inverterVelocidade = !inverterVelocidade;

      if (animation == idleAnimation) {
        animation = invertedIdleAnimation;
      } else if (animation == invertedIdleAnimation) {
        animation = idleAnimation;
      }
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Verifique se o booleano `inverterVelocidade` é verdadeiro e inverta a velocidade vertical
    if (gravity) {
      if (inverterVelocidade) {
        vy = -ay;
      } else {
        vy = ay;
      }
    } else {
      vy = 0;
    }

    if (position.y - 40 >= gameRef.size.y || position.y <= 0) {
      ay = 0;
      vy = 0;
      gameOver = true;
      removeFromParent();
      Get.to(GameOverScreen(gameController.score.value.floor()));
    }
    position.x += vx * dt;
    position.y += vy * dt;
  }
}
