import 'package:survival/recipe/recipe.dart';

final stickRecipe = Recipe(
  pattern: [
    "palo",
    "palo",
    "palo",
    "palo",
    "palo",
    "palo",
    "palo",
    "palo",
    "palo",
  ],
  resultName: "madera",
  resultImage: "assets/images/wood.png",
  resutlQuantity: 10,
);

final picoRecipe = Recipe(
  pattern: ["stone", "stone", "stone", null, "palo", null, null, "palo", null],
  resultName: "pico",
  resultImage: "assets/images/pico.png",
  resutlQuantity: 1,
);

final hachaRecipe = Recipe(
  pattern: ["stone", "stone", null, "stone", "palo", null, null, "palo", null],
  resultName: "hacha",
  resultImage: "assets/images/hacha.png",
  resutlQuantity: 1,
);

final List<Recipe> recipes = [stickRecipe, picoRecipe, hachaRecipe];
