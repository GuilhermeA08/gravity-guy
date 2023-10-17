import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/sprite.dart';
import 'package:get/get.dart';

import 'game.dart';
import 'game_controller.dart';
import 'gameover.dart';

class Person extends SpriteAnimationComponent
    with
        TapCallbacks,
        HasGameRef<GravityGuyGame>,
        HasCollisionDetection,
        CollisionCallbacks {
  Person() : super(size: Vector2(32, 32));
  double vx = 0; //m/s
  double vy = 0; //m/s
  double ax = 0;
  double ay = 300;
  bool inverterVelocidade = false;
  final GameController gameController = Get.put(GameController());

  int countApple = 0;
  late SpriteSheet idleSpriteSheet, invertedIdleSpriteSheet;
  late SpriteAnimation idleAnimation, invertedIdleAnimation;
  //final animation = spriteSheet.createAnimation(0, stepTime: 0.1);
  bool gameOver = false;
  @override
  void onLoad() async {
    add(
      RectangleHitbox.relative(
        Vector2(0.5, 0.5), // Ajuste a posição da hitbox conforme necessário
        // size: Vector2(32, 32), // Ajuste o tamanho da hitbox conforme necessário
        parentSize: size,
      ),
    );
    //sprite = await gameRef.loadSprite('person.png');
    position = gameRef.size / 2;
    size = Vector2(100.0, 100.0);
    anchor = Anchor.center;

    //debugMode = true;
    idleSpriteSheet = SpriteSheet(
      image: await gameRef.images.load('spacerun.png'),
      srcSize: Vector2.all(150.0),
    );
    invertedIdleSpriteSheet = SpriteSheet(
      image: await gameRef.images.load('invertedrun.png'),
      srcSize: Vector2.all(150.0),
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
  void onCollisionStart(Set<Vector2> points, PositionComponent other) {
    print(other);
    print("colidiu com algo");
    super.onCollisionStart(points, other);
  }

  void jump() {
    inverterVelocidade = !inverterVelocidade;

    if (animation == idleAnimation) {
      animation = invertedIdleAnimation;
    } else if (animation == invertedIdleAnimation) {
      animation = idleAnimation;
    }

  }

  @override
  void update(double dt) {
    super.update(dt);

    // Verifique se o booleano `inverterVelocidade` é verdadeiro e inverta a velocidade vertical
    if (inverterVelocidade) {
      vy = -ay;
    } else {
      vy = ay;
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
