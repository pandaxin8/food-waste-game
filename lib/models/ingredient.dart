import 'package:cloud_firestore/cloud_firestore.dart';

class Ingredient {
  final String name;
  final String imageUrl; // to display the Ingredient
  final List<String> dietaryTags; // e.g. 'vegetarian', 'gluten-free',
  final int calories;
  // ... other potential attributes like cost, expiration, etc.

  Ingredient({
    required this.name,
    required this.imageUrl,
    required this.dietaryTags,
    required this.calories,
  });

  factory Ingredient.fromDocument(DocumentSnapshot doc) {
    return Ingredient(
      name: doc.get('name') as String,
      imageUrl: doc.get('imageUrl') as String,
      dietaryTags: List<String>.from(doc.get('dietaryTags')),
      calories: doc.get('calories') as int,
    );
  }
}