import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:survival/inventory/inventory.dart';
import 'package:survival/inventory/item.dart';
import 'package:survival/main.dart';
import 'package:flutter/services.dart';
import 'package:survival/thigs/hacha.dart';
import 'package:survival/thigs/tree.dart';

class Player extends SpriteComponent
    with HasGameRef<Survival>, KeyboardHandler {
  Vector2 movement = Vector2.zero();
  Vector2 velocity = Vector2.zero();
  late Inventory inventory;
  late Sprite woodSprite;
  late Sprite hachaSprite;

  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load("player.png");
    size = Vector2(70, 70);

    add(RectangleHitbox());
    woodSprite = await gameRef.loadSprite("wood.png");
    hachaSprite = await gameRef.loadSprite("hacha.png");
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
      accion();
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyE)) {
      toggleCrafteo();
    }
    return super.onKeyEvent(event, keysPressed);
  }

  void accion() async {
    bool action = false;

    final onHacha = inventory.items.any((item) => item.name == "hacha");

    if (onHacha) {
      final trees = game.children.whereType<Tree>().where(
        (tree) => tree.toRect().overlaps(toRect()),
      );
      for (final tree in trees) {
        action = true;
        tree.removeFromParent();
        inventory.addItem(
          Item(
            name: "madera",
            sprite: woodSprite,
            quantity: 2,
            imagePath: "assets/images/wood.png",
          ),
        );
      }
    }

    final hachas = game.children.whereType<Hacha>().where(
      (hacha) => hacha.toRect().overlaps(toRect()),
    );
    for (final hacha in hachas) {
      action = true;
      hacha.removeFromParent();
      inventory.addItem(
        Item(
          name: "hacha",
          sprite: hachaSprite,
          quantity: 1,
          imagePath: "assets/images/hacha.png",
        ),
      );
    }
  }

  void toggleCrafteo() {
    if (gameRef.overlays.isActive("Crafteo")) {
      gameRef.overlays.remove("Crafteo");
    } else {
      gameRef.overlays.add("Crafteo");
    }
  }
}
