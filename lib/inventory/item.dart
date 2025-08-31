import 'package:flame/components.dart';

class Item {
  final String name;
  final Sprite? sprite;
  int quantity;
  final String imagePath;

  Item({
    required this.name,
    this.sprite,
    this.quantity = 1,
    this.imagePath = "",
  });
}
