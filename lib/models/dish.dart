import "package:food_waste_game/models/guest.dart";
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

  bool doesSatisfyDietaryRestrictions(Guest guest) {
    return ingredients.every((ingredient) => 
    ingredient.dietaryTags.every((tag) => !guest.dietaryRestrictions.contains(tag))
  );
  }

  int calculateCalorieScore(Guest guest) {
    // example: calculate how close the dish is to the guest's calorie limit
    int totalCalories = ingredients.fold(0, (sum, ingredient) => sum + ingredient.calories);
    int differenceFromLimit = (guest.maxCalories - totalCalories).abs(); 
    return 100 - differenceFromLimit; // scale the result if needed
  }
}