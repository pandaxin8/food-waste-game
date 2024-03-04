import 'package:cloud_firestore/cloud_firestore.dart';

class Ingredient {
  final String name;
  final String imageUrl; // to display the Ingredient
  final List<String> dietaryTags; // e.g. 'vegetarian', 'gluten-free',
  final int calories;
  bool isSelected = false;
  int freshness = 100; // initial freshness (100 being freshest)
  bool isLocal = false;  // flag for local origin
  // ... other potential attributes like cost, expiration, etc.

  Ingredient({
    required this.name,
    required this.imageUrl,
    required this.dietaryTags,
    required this.calories,
    required this.isSelected,
    required this.freshness,
    required this.isLocal,
  });

  factory Ingredient.fromDocument(DocumentSnapshot doc) {
    return Ingredient(
      name: doc.get('name') as String,
      imageUrl: doc.get('imageUrl') as String,
      dietaryTags: List<String>.from(doc.get('dietaryTags')),
      calories: doc.get('calories') as int,
      isSelected: false,
      freshness: doc.get('freshness') as int? ?? 100,  // Read from Firestore, default to 100
      isLocal: doc.get('isLocal') as bool? ?? false,   // Read from Firestore, default to false
    );
  }

  // convert Ingredientto Map, for storing in Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'dietaryTags': dietaryTags,
      'calories': calories,
      'freshness': freshness,
      'isLocal': isLocal, 
    };
  }

  void decreaseFreshness() {
    if (freshness > 0) { 
      freshness -= 10; // Or any decrement value you choose
    }
  }
}