import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:survival/main.dart';

class Hacha extends SpriteComponent {
  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load('hacha.png');
    size = Vector2.all(32);
    add(RectangleHitbox());
    return super.onLoad();
  }
}
