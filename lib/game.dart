import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flame/parallax.dart';
import 'package:flappybird/game_controller.dart';
import 'package:flappybird/person.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  //Flame.device.setLandscape();
  runApp(GameWidget(
    game: FlappyBirdGame(),
    loadingBuilder: (context) {
      return Text("loading");
    },
  ));
}

class FlappyBirdGame extends FlameGame with TapCallbacks {
  late Person _person;
  final scoreStyle = TextPaint(
    style: TextStyle(
      fontSize: 48.0,
      color: BasicPalette.white.color,
    ),
  );

  int velocityScore = 2;
  late TextComponent tc;

  final GameController gameController = Get.put(GameController());

  @override
  Future<void> onLoad() async {
    final images = [
      loadParallaxImage('day.jpg', repeat: ImageRepeat.repeat),
      loadParallaxImage(
        'stone.png',
        repeat: ImageRepeat.repeatX,
        alignment: Alignment.bottomCenter,
        fill: LayerFill.none,
      ),
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
    //cria texto de pontos
    tc = TextComponent(
      text: gameController.score.value.floor().toString(),
      textRenderer: scoreStyle,
      anchor: Anchor.topCenter,
      position: Vector2(size.x / 2, 40),
    );
    add(tc);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_person.gameOver == true) {
      tc.text = "GAME OVER\n${gameController.score.value.floor()} Pontos";
    } else {
      tc.text = gameController.score.value.floor().toString();
      gameController.score.value += velocityScore * dt;
    }
  }

  @override
  void onTapUp(TapUpEvent event) {
    // Do something in response to a tap event
    print("tocou jogo");
    _person.jump();
  }
}
