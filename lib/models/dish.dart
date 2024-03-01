import "package:cloud_firestore/cloud_firestore.dart";
import "package:food_waste_game/models/guest.dart";
import "package:food_waste_game/models/ingredient.dart";

class Dish {
  final String name;
  final List<Ingredient> ingredients;
  final int prepTime;
  final List<String> satisfiesTags;

  Dish({
    required this.name,
    required this.ingredients, 
    required this.prepTime,
    required this.satisfiesTags,
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