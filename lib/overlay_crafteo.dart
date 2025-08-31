import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:survival/inventory/inventory.dart';
import 'package:survival/inventory/item.dart';
import 'package:survival/recipe/recipe_craft.dart';

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

  // Cargar sprite usando Flame
  Future<Sprite> loadSprite(String path) async {
    // Solo pasa el nombre del archivo, no toda la ruta
    final fileName = path.split('/').last; // "palo.jpg"
    final image = await Flame.images.load(fileName);
    return Sprite(image);
  }

  // Verificar si la grilla coincide con alguna receta
  Future<Item?> checkCraftingGrid() async {
    for (final recipe in recipes) {
      bool match = true;

      for (int i = 0; i < 9; i++) {
        final gridItem = craftingGrid[i]?.name;
        final recipeItem = recipe.pattern[i];

        // Si en la receta hay un material y no coincide, no es válida
        if (recipeItem != null && recipeItem != gridItem) {
          match = false;
          break;
        }

        // Si en la receta hay null pero en la grilla hay algo, tampoco es válida
        if (recipeItem == null && gridItem != null) {
          match = false;
          break;
        }
      }

      if (match) {
        final sprite = await loadSprite(recipe.resultImage);
        return Item(
          name: recipe.resultName,
          imagePath: recipe.resultImage,
          sprite: sprite,
          quantity: recipe.resutlQuantity,
        );
      }
    }
    return null;
  }

  // Manejar crafteo
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
        // Limpiar la grilla y resultado
        for (int i = 0; i < craftingGrid.length; i++) {
          craftingGrid[i] = null;
        }
        selectedItem = null;
        currentResult = null;
      });
    }
  }

  // Reiniciar crafteo
  void resetCrafting() {
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
      }
      selectedItem = null;
      currentResult = null;
    });
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
                // Grilla 3x3 de crafteo
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
                            await handleCrafting();
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
                // Resultado del crafteo
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
            // Botones
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: confirmCrafting,
                  child: const Text("Craftear"),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: resetCrafting,
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
