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
}