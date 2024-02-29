import 'package:food_waste_game/models/dish.dart';

class Guest {
  final String name; // for a bit of personality
  //final String preferenceIconUrl; // visual cue
  final String iconUrl; // visual cue
  final List<String> preferences;
  final List<String> dietaryRestrictions;
  final int maxCalories; // calorie limit

  Guest({
    required this.name,
    required this.iconUrl,
    required this.preferences,
    required this.dietaryRestrictions,
    required this.maxCalories,
  });

  // bool isSatisfiedBy(Dish dish) {
  //   return dish.doesSatisfyDietaryRestrictions(this); //&& dish.calculateCalorieScore(this) >= 50; // assuming a minimum calorie target
  // }

  bool isSatisfiedBy(Dish dish) {
    // First check if the dish satisfies the dietary restrictions
    if (!dish.doesSatisfyDietaryRestrictions(this)) return false; 

    // Check the calorie score
    int calorieScore = dish.calculateCalorieScore(this); 
    if (calorieScore < 50) return false; // Ensure there's a minimum calorie score

    // Check if any of the guest's preferences match the dish's satisfiesTags
    bool hasPreferenceMatch = preferences.any((preference) => 
      dish.satisfiesTags.contains(preference));

    // Apply a preference bonus if there's a match
    if (hasPreferenceMatch) {
      calorieScore += 20; // Bonus for matching preferences
    }

    // If you have a calorie limit, you might want to check if the calorieScore is less than maxCalories
    if (calorieScore > maxCalories) return false; // Ensure calorie score is within the limit

    return true; // The dish satisfies the guest if all conditions are met
  }
}