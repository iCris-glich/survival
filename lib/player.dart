import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:survival/inventory/inventory.dart';
import 'package:survival/inventory/item.dart';
import 'package:survival/main.dart';
import 'package:flutter/services.dart';
import 'package:survival/thigs/tree.dart';

class Player extends SpriteComponent
    with HasGameRef<Survival>, KeyboardHandler {
  Vector2 movement = Vector2.zero();
  Vector2 velocity = Vector2.zero();
  late Inventory inventory;
  late Sprite woodSprite;

  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load("player.png");
    size = Vector2(70, 70);

    add(RectangleHitbox());
    woodSprite = await gameRef.loadSprite("wood.png");

    return super.onLoad();
  }

  @override
  void update(double dt) {
    // TODO: implement update
    super.update(dt);
    velocity = movement * 200;
    position += velocity * dt;

    position.clamp(
      Vector2.zero(),
      Vector2(game.size.x - size.x, game.size.y - size.y),
    );
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    movement = Vector2.zero();
    if (keysPressed.contains(LogicalKeyboardKey.keyA)) {
      movement.x = -1;
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyD)) {
      movement.x = 1;
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyW)) {
      movement.y = -1;
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyS)) {
      movement.y = 1;
    }
    if (keysPressed.contains(LogicalKeyboardKey.space)) {
      talar();
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyE)) {
      crafteo();
    }
    return super.onKeyEvent(event, keysPressed);
  }

  void talar() async {
    final hits = game.children.whereType<Tree>().where(
      (tree) => tree.toRect().overlaps(toRect()),
    );
    for (final tree in hits) {
      tree.removeFromParent();
      inventory.addItem(Item(name: "madera", sprite: woodSprite));
    }
  }

  void crafteo() async {}
}
