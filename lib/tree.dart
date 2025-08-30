import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:survival/main.dart';

class Tree extends SpriteComponent {
  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load("tree.png");
    size = Vector2(170, 170);

    add(RectangleHitbox());
    return super.onLoad();
  }
}

class Water extends SpriteComponent with HasGameRef<Survival> {
  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load("water.jpg");
    add(RectangleHitbox());
    return super.onLoad();
  }

  bool nearWater() {
    for (final waterTiles in gameRef.waterTiles) {
      if (toRect().inflate(10).overlaps(waterTiles.toRect())) {
        return true;
      }
    }
    return false;
  }
}
