import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:survival/inventory/inventory.dart';
import 'package:survival/inventory/item.dart';
import 'package:survival/main.dart';
import 'package:flutter/services.dart';
import 'package:survival/thigs/hacha.dart';
import 'package:survival/thigs/stone.dart';
import 'package:survival/thigs/tree.dart';

class Player extends SpriteComponent
    with HasGameRef<Survival>, KeyboardHandler {
  Vector2 movement = Vector2.zero();
  Vector2 velocity = Vector2.zero();
  late Inventory inventory;
  late Sprite woodSprite;
  late Sprite hachaSprite;
  late Sprite stoneSprite;

  int selectedIndex = 0;

  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load("player.png");
    size = Vector2(70, 70);

    add(RectangleHitbox());
    woodSprite = await gameRef.loadSprite("wood.png");
    hachaSprite = await gameRef.loadSprite("hacha.png");
    stoneSprite = await gameRef.loadSprite("stone.png");
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

    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.digit1) selectedIndex = 0;
      if (event.logicalKey == LogicalKeyboardKey.digit2) selectedIndex = 1;
      if (event.logicalKey == LogicalKeyboardKey.digit3) selectedIndex = 2;
      if (event.logicalKey == LogicalKeyboardKey.digit4) selectedIndex = 3;
      if (event.logicalKey == LogicalKeyboardKey.digit5) selectedIndex = 4;
    }
    return super.onKeyEvent(event, keysPressed);
  }

  void accion() async {
    bool action = false;

    if (selectedIndex < inventory.items.length) {
      final selectedItem = inventory.items[selectedIndex];

      if (selectedItem.name == "hacha") {
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

    final stones = game.children.whereType<Stone>().where(
      (stone) => stone.toRect().overlaps(toRect()),
    );
    for (final stone in stones) {
      action = true;
      stone.removeFromParent();
      inventory.addItem(
        Item(
          name: "stone",
          sprite: stoneSprite,
          quantity: 1,
          imagePath: "assets/images/stone.png",
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
