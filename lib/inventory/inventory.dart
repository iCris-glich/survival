import 'package:survival/inventory/item.dart';

class Inventory {
  final List<Item> items = [];

  void addItem(Item item) {
    final existingIndex = items.indexWhere((i) => i.name == item.name);

    if (existingIndex != -1) {
      items[existingIndex].quantity += item.quantity;
    } else {
      items.add(item);
    }
  }
}
