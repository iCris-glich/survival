import 'dart:async';
import 'dart:math';

import 'package:fast_noise/fast_noise.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:survival/inventory/inventory.dart';
import 'package:survival/inventory/inventoryComponent.dart';
import 'package:survival/inventory/item.dart';
import 'package:survival/menu.dart';
import 'package:survival/overlay_crafteo.dart';
import 'package:survival/player.dart';
import 'package:survival/thigs/hacha.dart';
import 'package:survival/thigs/tree.dart';

void main() {
  final survival = Survival(); // ✅ instancia única del juego

  runApp(
    GameWidget(
      game: survival,
      overlayBuilderMap: {
        'MainMenu': (context, game) {
          return MainMenu(game: game as Survival);
        },
        'Crafteo': (context, game) {
          final survivalGame = game as Survival;
          return OverlayCrafteo(inventory: survivalGame.inventory);
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
  late Inventory inventory;
  late InventoryComponent inventorycomponent;
  List<SpriteComponent> waterTiles = [];

  final noise = PerlinNoise(seed: 12345);

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    player = Player();

    // cargar sprites
    water = await loadSprite("water.png");
    grass = await loadSprite("grass.jpg");
    dirt = await loadSprite("dirt.png");

    // generar mapa
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        double value = noise.getNoise2(x * 0.1, y * 0.7);

        Sprite sprite;
        if (value < -0.2) {
          sprite = water;
        } else if (value < 0.2) {
          sprite = grass;
        } else {
          sprite = dirt;
        }

        final tile = SpriteComponent(
          sprite: sprite,
          size: Vector2.all(tileSize),
          position: Vector2(x * tileSize, y * tileSize),
        );

        add(tile);

        if (sprite == water) {
          waterTiles.add(tile);
        }
      }
    }

    // agregar jugador
    add(player);
    camera.follow(player);

    // generar árboles aleatorios
    int createTree = 0;
    final random = Random();
    while (createTree < 50) {
      final tree = Tree();
      final x = random.nextDouble() * size.x;
      final y = random.nextDouble() * size.y;
      final pos = Vector2(x, y);

      if (!onWater(pos, tileSize, waterTiles)) {
        tree.position = pos;
        add(tree);
        createTree++;
      }
    }

    // agregar hacha en el suelo
    final hacha = Hacha();
    hacha.position = Vector2(50, 200);
    add(hacha);

    // inicializar inventario
    inventory = Inventory();
    inventorycomponent = InventoryComponent(inventory);
    add(inventorycomponent);

    // conectar inventario al jugador
    player.inventory = inventory;
  }

  void startGame() {
    overlays.remove("MainMenu");
  }

  bool onWater(
    Vector2 position,
    double tileSize,
    List<SpriteComponent> waterTiles,
  ) {
    for (final tile in waterTiles) {
      final reactTile = Rect.fromLTWH(tile.x, tile.y, tileSize, tileSize);
      if (reactTile.contains(Offset(position.x, position.y))) {
        return true;
      }
    }
    return false;
  }
}
