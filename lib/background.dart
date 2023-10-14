import 'package:flame/components.dart';
import 'package:flappybird/game.dart';

class Background extends SpriteComponent with HasGameRef<FlappyBirdGame> {
  @override
  onLoad() async {
    // TODO: implement onLoad
    super.onLoad();

    sprite = await gameRef.loadSprite("day.jpg");
    size = gameRef.size;
  }
}
