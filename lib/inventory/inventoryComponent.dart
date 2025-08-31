import 'dart:ui';
import 'package:flame/components.dart';
import 'package:survival/inventory/inventory.dart';

class InventoryComponent extends PositionComponent {
  final Inventory inventory;
  final int columns; // cuántos items por fila
  final double itemSize; // tamaño de cada sprite
  final double padding; // espacio entre items

  InventoryComponent(
    this.inventory, {
    this.columns = 8,
    this.itemSize = 64,
    this.padding = 5,
  });

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // fondo semi-transparente para el inventario
    final backgroundWidth = columns * (itemSize + padding) + padding;
    final totalRows = (inventory.items.length / columns).ceil();
    final backgroundHeight = totalRows * (itemSize + padding) + padding;

    canvas.drawRect(
      Rect.fromLTWH(5, 5, backgroundWidth, backgroundHeight),
      Paint()..color = const Color(0x88000000), // negro semitransparente
    );

    for (int i = 0; i < inventory.items.length; i++) {
      final item = inventory.items[i];

      // calcular fila y columna
      int row = i ~/ columns;
      int col = i % columns;

      final x = padding + col * (itemSize + padding);
      final y = padding + row * (itemSize + padding);

      // dibujar sprite
      item.sprite?.render(
        canvas,
        position: Vector2(x, y),
        size: Vector2.all(itemSize),
      );

      // dibujar cantidad encima del sprite
      TextPaint().render(
        canvas,
        "x${item.quantity}",
        Vector2(x + itemSize - 14, y + itemSize - 14),
      );
    }
  }
}
