import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Stone extends SpriteComponent {
  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load("stone.png");
    size = Vector2.all(32);
    add(RectangleHitbox());
    return super.onLoad();
  }
}
