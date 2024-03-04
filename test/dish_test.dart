import 'package:flutter_test/flutter_test.dart';
import 'package:food_waste_game/models/ingredient.dart';
import 'package:food_waste_game/models/guest.dart';
import 'package:food_waste_game/models/dish.dart'; 

void main() {
  group('Dish Matching Tests', () { // Organize tests into a group

    test('Salad satisfies a gluten-free, calorie-conscious guest', () {
      // Set up sample data
      Dish dish1 = Dish(name: 'Salad', satisfiesTags: [], prepTime: 5, unlockLevel:1, imagePath: '',ingredients: [
        Ingredient(name: 'Tomato', imageUrl: '...', dietaryTags: ['vegetarian'], calories: 20, isSelected: false, isLocal: false, freshness: 100),
        Ingredient(name: 'Lettuce', imageUrl: '...', dietaryTags: ['vegetarian', 'vegan'], calories: 10, isSelected: false,isLocal: false, freshness: 100)
      ]);
      Guest guest1 = Guest(name: 'Alice', iconUrl: 'assets/images/characters/cat-sprite.png', preferences: [], dietaryRestrictions: [], maxCalories: 500);

      // Assert the expected outcome 
      expect(guest1.isSatisfiedBy(dish1), true); 
    });

    // ... Add more tests with various scenarios (vegan guest, high-calorie dish, etc.)
  });
}