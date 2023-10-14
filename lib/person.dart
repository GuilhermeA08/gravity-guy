import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flappybird/gameover.dart';
import 'package:flappybird/spike.dart';
import 'package:flame/sprite.dart';
import 'package:get/get.dart';

import 'apple.dart';
import 'game.dart';

class Person extends SpriteAnimationComponent
    with
        TapCallbacks,
        HasGameRef<FlappyBirdGame>,
        HasCollisionDetection,
        CollisionCallbacks {
  Person() : super(size: Vector2(32, 32));
  double vx = 0; //m/s
  double vy = 0; //m/s
  double ax = 0;
  double ay = 300;
  bool inverterVelocidade = false;

  int countApple = 0;
  late SpriteSheet idleSpriteSheet, hitSpriteSheet;
  late SpriteAnimation idleAnimation, hitAnimation;
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
    hitSpriteSheet = SpriteSheet(
      image: await gameRef.images.load('hit.png'),
      srcSize: Vector2.all(32.0),
    );

    idleAnimation = idleSpriteSheet.createAnimation(
        row: 0, stepTime: 0.07, from: 0, to: 8, loop: true);
    hitAnimation = hitSpriteSheet.createAnimation(
        row: 0, stepTime: 0.2, from: 0, to: 10, loop: false);

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
    if (other is Spike) {
      print("colisão com spike");
      removeFromParent();
    } else if (other is Apple) {
      ++countApple;
    }
  }

  @override
  void onTapUp(TapUpEvent event) async {
    // Do something in response to a tap event
    //sprite = await gameRef.loadSprite('person2.png');
    scale = Vector2(1, -2);
    animation = hitAnimation;
    print("tocou person");
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    scale = Vector2(1.5, 1.5);
  }

  void jump() {
    inverterVelocidade = !inverterVelocidade;
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
      Get.to(GameOverScreen(countApple));
    }
    position.x += vx * dt;
    position.y += vy * dt;
  }
}
