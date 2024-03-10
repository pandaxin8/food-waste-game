import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_waste_game/models/dish.dart';

class Guest {
  final String name; // for a bit of personality
  //final String preferenceIconUrl; // visual cue
  final String iconUrl; // visual cue
  final List<String> preferences;
  final List<String> dietaryRestrictions;
  final int maxCalories; // calorie limit
  bool isSatisfied = false;

  Guest({
    required this.name,
    required this.iconUrl,
    required this.preferences,
    required this.dietaryRestrictions,
    required this.maxCalories,
    required this.isSatisfied,
  });

  factory Guest.fromDocument(DocumentSnapshot doc) {
    return Guest(
      name: doc.get('name') as String, // Access the 'name' field
      iconUrl: doc.get('iconUrl') as String, 
      preferences: List<String>.from(doc.get('preferences')), // Cast preferences as List<String>
      dietaryRestrictions: List<String>.from(doc.get('dietaryRestrictions')),
      maxCalories: doc.get('maxCalories') as int,
      isSatisfied: false,
    );
  }

  // bool isSatisfiedBy(Dish dish) {
  //   return dish.doesSatisfyDietaryRestrictions(this); //&& dish.calculateCalorieScore(this) >= 50; // assuming a minimum calorie target
  // }

  bool isSatisfiedBy(Dish dish) {
    // First check if the dish satisfies the dietary restrictions
    print('isSatisfiedByMethod:');
    print('dish name: $dish');
    if (!dish.doesSatisfyDietaryRestrictions(this)) return false; 

    // Check the calorie score
    // int calorieScore = dish.calculateCalorieScore(this); 
    // if (calorieScore <= 10) return false; // Ensure there's a minimum calorie score
    // print('hello 3');

    // Check if any of the guest's preferences match the dish's satisfiesTags
    bool hasPreferenceMatch = preferences.any((preference) => 
      dish.satisfiesTags.contains(preference));

    print('hasPreferenceMatch:' + hasPreferenceMatch.toString());

    // Apply a preference bonus if there's a match
    // if (hasPreferenceMatch) {
    //   calorieScore += 20; // Bonus for matching preferences
    // }

    // If you have a calorie limit, you might want to check if the calorieScore is less than maxCalories
    // if (calorieScore > maxCalories) return false; // Ensure calorie score is within the limit
    // print('hello 4');

    return true; // The dish satisfies the guest if all conditions are met
  }
}