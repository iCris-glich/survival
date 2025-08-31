import 'package:survival/recipe/recipe.dart';

final stickRecipe = Recipe(
  pattern: ["madera", null, null, "madera", null, null, "madera", null, null],
  resultName: "palo",
  resultImage: "assets/images/palo.jpg",
  resutlQuantity: 10,
);

final hachaRecipe = Recipe(
  pattern: [
    "madera",
    "madera",
    "madera",
    null,
    "palo",
    null,
    null,
    "palo",
    null,
  ],
  resultName: "hacha",
  resultImage: "assets/images/hacha.png",
  resutlQuantity: 1,
);

final List<Recipe> recipes = [stickRecipe, hachaRecipe];
