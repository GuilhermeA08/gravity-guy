import 'package:flame/components.dart';

import 'game.dart';

class Background extends SpriteComponent with HasGameRef<GravityGuyGame> {
  @override
  onLoad() async {
    // TODO: implement onLoad
    super.onLoad();

    sprite = await gameRef.loadSprite("day.jpg");
    size = gameRef.size;
  }
}
