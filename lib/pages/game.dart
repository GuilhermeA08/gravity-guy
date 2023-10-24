import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gravityguy/components/apple.dart';
import 'package:gravityguy/components/person.dart';
import 'package:gravityguy/components/terrain.dart';
import 'package:gravityguy/controllers/game_controller.dart';

class GravityGuyGame extends FlameGame
    with TapCallbacks, HasCollisionDetection, CollisionCallbacks {
  late Person _person;
  late Apple _apple;

  final BuildContext context;
  //variavel que armazena em segundos o tempo que o jogo está rodando
  double time = 0;

  GravityGuyGame(this.context);

  final scoreStyle = TextPaint(
    style: TextStyle(
      fontSize: 48.0,
      color: BasicPalette.white.color,
    ),
  );

  int velocityScore = 2;
  late TextComponent tc;
  late bool changePosition = true;
  bool initialPlataform = true;

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
    //texto deve ficar a frente de todos os outros componentes
    tc = TextComponent(
      text: gameController.score.value.floor().toString(),
      textRenderer: scoreStyle,
      anchor: Anchor.topCenter,
      position: Vector2(size.x / 2, 40),
      priority: layers.length + 1,
    );
    add(tc);

    _apple = Apple();
    // add(_apple);
  }

  @override
  Future<void> update(double dt) async {
    // Atualiza a variavel time com tempo decorrido
    time += dt;
    // print(time);
    if (time > 1.1) {
      randomizePlatforms();
      time = 0;
    }

    if (_person.gameOver != true) {
      tc.text = gameController.score.value.floor().toString();
      gameController.score.value += velocityScore * dt;
    }
    _apple.vx = 0;

    super.update(dt);
  }

  @override
  void onTapDown(TapDownEvent event) {
    // Do something in response to a tap event
    print("tocou jogo");
    _person.jump();
  }

  Future<void> randomizePlatforms() async {
    var n = Random().nextInt(3) + 5;
    var currentY = randomizeYCoord();
    var currentX = size.x;

    // print("Y gerado $currentY");

    // Se for a primeira plataforma, ela será criada na posição inicial
    if (initialPlataform) {
      currentX = 100.0;
      currentY = 500.0;
      n = 8;
      initialPlataform = false;
    }

    for (var i = 0; i < n; i++) {
      Terrain terrain = Terrain(currentX, currentY);
      add(terrain);
      // print("terreno criado $i");

      currentX += 60;
    }

    if (initialPlataform) {
      randomizePlatforms();
    }
  }

  double randomizeYCoord() {
    // pega o tamanho da tela
    var size = MediaQuery.of(context).size.height;

    changePosition = !changePosition;

    //Se changedPosition for true, o y será gerado entre o topo da tela e o primeiro terço da tela
    //Se changedPosition for false, o y será gerado entre o meio da tela e o ultimo terço da tela

    if (changePosition) {
      return Random().nextDouble() * (size / 3) + 30;
    } else {
      return Random().nextDouble() * (size / 3) + (size / 3) + (size / 3) - 30;
    }
  }
}
