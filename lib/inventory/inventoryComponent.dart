import 'dart:ui';

import 'package:flame/components.dart';
import 'package:survival/inventory/inventory.dart';

class InventoryComponent extends PositionComponent {
  final Inventory inventory;

  InventoryComponent(this.inventory);

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    double x = 10;
    double y = 10;

    for (final item in inventory.items) {
      item.sprite.render(
        canvas,
        position: Vector2(x, y),
        size: Vector2.all(32),
      );

      TextPaint().render(canvas, "x${item.quantity}", Vector2(x + 35, y + 10));

      y += 40;
    }
  }
}
