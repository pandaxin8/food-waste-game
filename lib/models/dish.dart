import "package:cloud_firestore/cloud_firestore.dart";
import "package:food_waste_game/models/guest.dart";
import "package:food_waste_game/models/ingredient.dart";

class Dish {
  final String name;
  final List<Ingredient> ingredients;
  final int prepTime;
  final List<String> satisfiesTags;
  final int unlockLevel; // new field to determine when dish gets unlocked
  final String imagePath;

  Dish({
    required this.name,
    required this.ingredients, 
    required this.prepTime,
    required this.satisfiesTags,
    required this.unlockLevel,
    required this.imagePath,
  });

  static Future<Dish> fromDocument(DocumentSnapshot doc) async {
    // Fetch ingredients asynchronously before creating the Dish
    var ingredientRefs = doc.get('ingredients');
    if (ingredientRefs is! List || ingredientRefs.any((ref) => ref is! DocumentReference)) {
      throw Exception('Expected list of DocumentReferences for ingredients');
    }
    var ingredients = await _getIngredientsFromReferences(ingredientRefs.cast<DocumentReference>());
    return Dish(
      name: doc.get('name') as String,
      prepTime: doc.get('prepTime') as int,
      satisfiesTags: List<String>.from(doc.get('satisfiesTags')),
      ingredients: ingredients, // Pass the List<Ingredient> here
      unlockLevel: doc.get('unlockLevel') as int,
      imagePath: doc.get('imagePath') as String,
    );
  }

  static Future<List<Ingredient>> _getIngredientsFromReferences(List<dynamic> refs) async {
    List<Ingredient> ingredients = [];
    for (var ref in refs) {
      if (ref is DocumentReference) {
        DocumentSnapshot<Object?> ingredientDoc = await ref.get();
        ingredients.add(Ingredient.fromDocument(ingredientDoc));
      } else {
        // Handle the case where the data is not a DocumentReference
        throw Exception('Expected a DocumentReference, but got a different type');
      }
    }
    return ingredients;
  }


  bool doesSatisfyDietaryRestrictions(Guest guest) {
    return ingredients.every((ingredient) =>
    !ingredient.dietaryTags.any((tag) => guest.dietaryRestrictions.contains(tag))
  );
  }

  int calculateCalorieScore(Guest guest) {
    // example: calculate how close the dish is to the guest's calorie limit
    int totalCalories = ingredients.fold(0, (sum, ingredient) => sum + ingredient.calories);
    int differenceFromLimit = (guest.maxCalories - totalCalories).abs(); 
    return 100 - differenceFromLimit; // scale the result if needed
  }

  // Method to calculate the total calories of the dish
  int calculateTotalCalories() {
    return ingredients.fold(0, (sum, ingredient) => sum + ingredient.calories);
  }

  // convert Dish to Map, for storing in Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'ingredients': ingredients.map((i) => i.toMap()).toList(),
      'prepTime': prepTime,
      'satisfiesTags': satisfiesTags,
      'unlockLevel': unlockLevel,
      'imagePath' : imagePath,
    };
  }
}