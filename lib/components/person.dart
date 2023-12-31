import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/sprite.dart';
import 'package:get/get.dart';
import 'package:gravityguy/components/terrain.dart';
import 'package:gravityguy/controllers/game_controller.dart';
import 'package:gravityguy/pages/game.dart';
import 'package:gravityguy/pages/gameover.dart';

class Person extends SpriteAnimationComponent
    with TapCallbacks, HasGameRef<GravityGuyGame>, CollisionCallbacks {
  double vx = 0; //m/s
  double vy = 0; //m/s
  double ax = 0;
  double ay = 400;

  var pulos = 0;
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

    // debugMode = true;
    idleSpriteSheet = SpriteSheet(
      image: await gameRef.images.load('spacerun3.png'),
      srcSize: Vector2(150.0, 102.0),
    );
    invertedIdleSpriteSheet = SpriteSheet(
      image: await gameRef.images.load('invertedrun3.png'),
      srcSize: Vector2(150.0, 102.0),
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
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Terrain) {
      gravity = false;

      //Se o personagem está a baixo do chão, mudar o posição do personagem para logo a baixo do chão
      if (intersectionPoints.first.y > other.position.y) {
        position.y = (other.position.y + other.size.y / 2 + size.y / 2) - 3;
      }

      //Se o personagem está a cima do chão, mudar o posição do personagem para logo a cima do chão

      if (intersectionPoints.first.y < other.position.y) {
        position.y = (other.position.y - other.size.y / 2 - size.y / 2) + 3;
      }

      // Se o personagem colidir com o chão pela esquerda a gravidade continua sendo true
      // if (points.first.x < other.position.x) {
      //   gravity = true;
      // }
    }
    super.onCollision(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);

    if (other is Terrain) {
      gravity = true;
    }
  }

  void jump() {
    // Se o personagem estiver no chão, ele pode pular
    if (!gravity) {
      gravity = true;

      if (inverterVelocidade) {
        position.y += 10;
      } else {
        position.y -= 10;
      }

      update(0.019701);

      inverterVelocidade = !inverterVelocidade;

      if (animation == idleAnimation) {
        animation = invertedIdleAnimation;
      } else if (animation == invertedIdleAnimation) {
        animation = idleAnimation;
      }
    }
  }

  @override
  void update(double dt) async{
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

      await gameController.insert();

      Get.off(GameOverScreen(gameController.score.value.floor()));
    }
    // position.x += vx * dt;
    position.y += vy * dt;
    // print(dt);
    super.update(dt);
  }
}
