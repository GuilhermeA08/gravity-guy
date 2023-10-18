import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'apple.dart';
import 'game_controller.dart';
import 'person.dart';
import 'terrain.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  //Flame.device.setLandscape();
  runApp(GameWidget(
    game: GravityGuyGame(),
  ));
}

class GravityGuyGame extends FlameGame
    with TapCallbacks, HasCollisionDetection, CollisionCallbacks {
  late Person _person;
  late Apple _apple;
  
  final scoreStyle = TextPaint(
    style: TextStyle(
      fontSize: 48.0,
      color: BasicPalette.white.color,
    ),
  );

  int velocityScore = 2;
  late TextComponent tc;
  late bool changePosition = false;

  final GameController gameController = Get.put(GameController());

  @override
  Future<void> onLoad() async {
    final images = [
      loadParallaxImage('day.jpg', repeat: ImageRepeat.repeat),
    ];

    final layers = images.map((image) async => ParallaxLayer(
      await image,
      velocityMultiplier: Vector2((images.indexOf(image) + 1) * 2.0, 0),
    ));

    final parallaxComponent = ParallaxComponent(
      parallax: Parallax(
        await Future.wait(layers),
        baseVelocity: Vector2(50, 0),
      ),
    );

    add(parallaxComponent);

    //cria personagem principal
    _person = Person();
    add(_person);

    await randomizePlatforms();

    //cria texto de pontos
    tc = TextComponent(
      text: gameController.score.value.floor().toString(),
      textRenderer: scoreStyle,
      anchor: Anchor.topCenter,
      position: Vector2(size.x / 2, 40),
    );
    add(tc);

    _apple = Apple();
    // add(_apple);
  }

  @override
  Future<void> update(double dt) async {
    super.update(dt);

    if (_person.gameOver != true) {
      tc.text = gameController.score.value.floor().toString();
      gameController.score.value += velocityScore * dt;
    }
    _apple.vx = 0;
  }

  @override
  void onTapUp(TapUpEvent event) {
    // Do something in response to a tap event
    // print("tocou jogo");
    _person.jump();
  }

  Future<void> randomizePlatforms() async {
    var n = Random().nextInt(5) + 3;
    var currentX = 100.0;

    for (var i = 0; i < n; i++) {
      Terrain terrain = Terrain(currentX, 0.0);
      add(terrain);

      currentX += 60;
    }
  }
}
