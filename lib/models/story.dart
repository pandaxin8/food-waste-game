import 'package:food_waste_game/models/character.dart';

class StorySegment {
  final String id;
  final String text;
  final Character character;
  final List<String>? imagePaths;
  final List<String>? choices;

  StorySegment({
    required this.id,
    required this.text,
    required this.character,
    this.imagePaths,
    this.choices,
  });
  // ... Additional methods and properties as needed ...
}