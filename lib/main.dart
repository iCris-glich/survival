import 'dart:async';

import 'package:fast_noise/fast_noise.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:survival/menu.dart';
import 'package:survival/player.dart';
import 'package:survival/tree.dart';

void main() {
  runApp(
    GameWidget(
      game: Survival(),
      overlayBuilderMap: {
        'MainMenu': (context, game) {
          return MainMenu(game: game as Survival);
        },
      },
      initialActiveOverlays: const ["MainMenu"],
    ),
  );
}

class Survival extends FlameGame with HasKeyboardHandlerComponents {
  final int width = 50;
  final int height = 30;
  final double tileSize = 32;

  late Sprite water;
  late Sprite grass;
  late Sprite dirt;
  late Player player;

  final noise = PerlinNoise(seed: 12345);

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    final player = Player();

    water = await loadSprite("water.png");
    grass = await loadSprite("grass.jpg");
    dirt = await loadSprite("dirt.png");

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        double value = noise.getNoise2(x * 0.1, y * 0.7);

        Sprite sprite;
        if (value < -0.13) {
          sprite = water;
        } else if (value < 0.1) {
          sprite = grass;
        } else {
          sprite = dirt;
        }

        add(
          SpriteComponent(
            sprite: sprite,
            size: Vector2.all(tileSize),
            position: Vector2(x * tileSize, y * tileSize),
          ),
        );
      }
    }
    add(player);
    camera.follow(player);

    final tree = Tree();
    tree.position = Vector2(100, 100);
    add(tree);
  }

  void startGame() {
    overlays.remove("MainMenu");
  }
}
