import 'package:flame/components.dart';
import 'package:flame/collisions.dart';

class BlockGame extends SpriteComponent with CollisionCallbacks {
  BlockGame(Vector2 position, Sprite sprite)
    : super(
        sprite: sprite,
        position: position,
        size: Vector2.all(32), // tamaño del bloque
      ) {
    add(RectangleHitbox()); // para impedir el paso
  }
}
