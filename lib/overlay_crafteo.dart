import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:survival/inventory/inventory.dart';
import 'package:survival/inventory/item.dart';

class OverlayCrafteo extends StatefulWidget {
  final Inventory inventory;

  const OverlayCrafteo({super.key, required this.inventory});

  @override
  State<OverlayCrafteo> createState() => _OverlayCrafteoState();
}

class _OverlayCrafteoState extends State<OverlayCrafteo> {
  Item? selectedItem; // Item seleccionado
  List<Item?> craftingGrid = List.filled(9, null); // 3x3 grid
  Item? currentResult; // Resultado de la receta

  Future<Sprite> loadSprite(String path) async {
    final image = await Flame.images.load(path);
    return Sprite(image);
  }

  // Función para revisar recetas
  Future<Item?> checkCraftingGrid() async {
    if (craftingGrid[0]?.name == "madera" &&
        craftingGrid[3]?.name == "madera" &&
        craftingGrid[6]?.name == "madera") {
      final sprite = await loadSprite("palo.jpg");
      return Item(
        name: 'palo',
        imagePath: "assets/images/palo.jpg",
        sprite: sprite,
        quantity: 10,
      );
    }
    return null;
  }

  // Maneja el crafteo
  Future<void> handleCrafting() async {
    final result = await checkCraftingGrid();
    setState(() {
      currentResult = result;
    });
  }

  // Confirmar crafteo y agregar al inventario
  void confirmCrafting() {
    if (currentResult != null) {
      final invIndex = widget.inventory.items.indexWhere(
        (i) => i.name == currentResult!.name,
      );
      setState(() {
        if (invIndex != -1) {
          widget.inventory.items[invIndex].quantity += currentResult!.quantity;
        } else {
          widget.inventory.items.add(currentResult!);
        }
        // Limpia la grilla y resultado
        for (int i = 0; i < craftingGrid.length; i++) {
          craftingGrid[i] = null;
        }
        selectedItem = null;
        currentResult = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CupertinoColors.systemGrey.withOpacity(0.8),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Crafteo Overlay',
              style: TextStyle(
                color: CupertinoColors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Cuadro 3x3 para crafteo
                Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                        ),
                    itemCount: 9,
                    itemBuilder: (context, index) {
                      final item = craftingGrid[index];
                      return GestureDetector(
                        onTap: () async {
                          if (selectedItem != null) {
                            setState(() {
                              craftingGrid[index] = selectedItem;
                              selectedItem = null;
                            });
                            await handleCrafting(); // revisa receta
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: Colors.white,
                          ),
                          child: item != null
                              ? Image.asset(item.imagePath)
                              : null,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 20),
                // Cuadro solitario para resultado
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: currentResult != null
                        ? Image.asset(currentResult!.imagePath)
                        : const Text("= ?"),
                  ),
                ),
                const SizedBox(width: 50),
                // Inventario
                Container(
                  height: 250,
                  width: 350,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 4,
                          crossAxisSpacing: 4,
                        ),
                    itemCount: widget.inventory.items.length,
                    itemBuilder: (context, index) {
                      final item = widget.inventory.items[index];
                      return GestureDetector(
                        onTap: () {
                          if (item.quantity > 0) {
                            setState(() {
                              selectedItem = item;
                              item.quantity--;
                            });
                          }
                        },
                        child: Column(
                          children: [
                            Expanded(
                              child: Image.asset(
                                item.imagePath,
                                fit: BoxFit.contain,
                              ),
                            ),
                            Text("${item.quantity}"),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: confirmCrafting,
                  child: const Text("Craftear"),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      for (int i = 0; i < craftingGrid.length; i++) {
                        final item = craftingGrid[i];
                        if (item != null) {
                          final invIndex = widget.inventory.items.indexWhere(
                            (inv) => inv.name == item.name,
                          );
                          if (invIndex != -1) {
                            widget.inventory.items[invIndex].quantity += 1;
                          }
                          craftingGrid[i] = null;
                        }
                        selectedItem = null;
                        currentResult = null;
                      }
                    });
                  },
                  child: const Text("Reiniciar Crafteo"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
