import 'package:food_waste_game/models/guest.dart';
import 'package:food_waste_game/models/ingredient.dart';

class Level {
  final int levelNumber;
  final List<Guest> guests;
  final List<Ingredient> availableIngredients;
  //final int budget; // optional, for a resource challenge


  Level({
    required this.levelNumber,
    required this.guests,
    required this.availableIngredients,
    //this.budget,
  });
}