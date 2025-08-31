import 'dart:ui';
import 'package:flame/components.dart';
import 'package:survival/inventory/inventory.dart';

class HotbarComponent extends PositionComponent {
  final Inventory inventory;
  final int slots; // cantidad de slots visibles en la hotbar
  final double itemSize;
  final double padding;
  int selectedIndex = 0; // slot seleccionado

  HotbarComponent(
    this.inventory, {
    this.slots = 5,
    this.itemSize = 64,
    this.padding = 8,
  });

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final backgroundWidth = slots * (itemSize + padding) + padding;
    final backgroundHeight = itemSize + padding * 2;

    // fondo semitransparente
    canvas.drawRect(
      Rect.fromLTWH(5, 5, backgroundWidth, backgroundHeight),
      Paint()..color = const Color(0x88000000),
    );

    for (int i = 0; i < slots; i++) {
      final x = padding + i * (itemSize + padding);
      final y = padding;

      // marco del slot
      final rect = Rect.fromLTWH(x, y, itemSize, itemSize);
      final borderPaint = Paint()
        ..color = (i == selectedIndex)
            ? const Color(0xFFFFFF00)
            : const Color(0xFFFFFFFF) // amarillo si seleccionado
        ..style = PaintingStyle.stroke
        ..strokeWidth = (i == selectedIndex) ? 4 : 1;

      canvas.drawRect(rect, borderPaint);

      if (i < inventory.items.length) {
        final item = inventory.items[i];

        // sprite del item
        item.sprite?.render(
          canvas,
          position: Vector2(x, y),
          size: Vector2.all(itemSize),
        );

        // cantidad
        TextPaint().render(
          canvas,
          "${item.quantity}",
          Vector2(x + itemSize - 18, y + itemSize - 18),
        );
      }
    }
  }
}
