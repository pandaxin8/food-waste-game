import "package:food_waste_game/models/ingredient.dart";

class Dish {
  final String name;
  final List<Ingredient> ingredients;
  final int prepTime; // if want a time constraint
  final List<String> satisfiesTags; // which dietary preferences it matches

  Dish({
    required this.name,
    required this.ingredients,
    required this.prepTime,
    required this.satisfiesTags,
  });
}