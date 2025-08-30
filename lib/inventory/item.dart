import 'package:flame/components.dart';

class Item {
  final String name;
  final Sprite sprite;
  int quantity;

  Item({required this.name, required this.sprite, this.quantity = 1});
}
