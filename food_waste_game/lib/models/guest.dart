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
}