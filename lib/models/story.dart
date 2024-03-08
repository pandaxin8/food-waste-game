import 'package:food_waste_game/models/character.dart';

class StorySegment {
  final String id;
  final String text;
  final Character character;
  final String? imagePath;
  final List<String>? choices;

  StorySegment({
    required this.id,
    required this.text,
    required this.character,
    this.imagePath,
    this.choices,
  });
  // ... Additional methods and properties as needed ...
}