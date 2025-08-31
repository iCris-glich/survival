import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Tree extends SpriteComponent {
  int life = 100;

  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load("tree.png");
    size = Vector2(170, 170);

    add(RectangleHitbox());
    return super.onLoad();
  }
}
