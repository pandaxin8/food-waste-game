import 'package:food_waste_game/models/dish.dart';

class Guest {
  final String name; // for a bit of personality
  final String preferenceIcon; // visual cue
  final List<String> dietaryRestrictions;
  final int maxCalories; // calorie limit

  Guest({
    required this.name,
    required this.preferenceIcon,
    required this.dietaryRestrictions,
    required this.maxCalories,
  });

  // bool isSatisfiedBy(Dish dish) {
  //   return dish.doesSatisfyDietaryRestrictions(this); //&& dish.calculateCalorieScore(this) >= 50; // assuming a minimum calorie target
  // }

  bool isSatisfiedBy(Dish dish) {
  if (!dish.doesSatisfyDietaryRestrictions(this)) return false; 

  // Calorie score - refined
  int calorieScore = dish.calculateCalorieScore(this); 
  if (calorieScore < 50) return false; // minimum threshold

  // Preference bonus
  if (dish.satisfiesTags.contains(preferenceIcon)) {
    calorieScore += 20; // bonus for matching preferences
  }
  return true; 
}
}