import 'package:food_waste_game/models/dish.dart';
import 'package:food_waste_game/models/guest.dart';
import 'package:food_waste_game/models/ingredient.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_waste_game/models/objective.dart';


class Level {
  final int levelNumber;
  final List<Guest> guests;
  final List<Ingredient> availableIngredients; // For levels focused on ingredient selection
  final List<Dish> availableDishes; // For levels focused on dish selection
  final String educationalGoal;
  final List<Objective> objectives;
  final List<String> unlocks; // Items or mechanics unlocked after completing the level

  //final int budget; // optional, for a resource challenge

  Level({
    required this.levelNumber,
    required this.guests,
    required this.availableIngredients,
    required this.availableDishes,
    required this.educationalGoal,
    required this.objectives,
    required this.unlocks,
    //this.budget,
  });

  bool get areAllObjectivesCompleted => objectives.every((obj) => obj.isCompleted);

  // Asynchronously create a Level instance from a Firestore document.
  static Future<Level> fromDocument(DocumentSnapshot doc) async {
    // Fetch and convert references
    var guestRefs = doc.get('guests').cast<DocumentReference>().toList(); // Add .toList()
    var ingredientRefs = doc.get('availableIngredients').cast<DocumentReference>().toList(); // Add .toList()
    var dishRefs = doc.get('availableDishes').cast<DocumentReference>().toList(); // Add .toList()
    

    var guests = await _getGuestsFromReferences(guestRefs.cast<DocumentReference>());
    var availableIngredients = await _getIngredientsFromReferences(ingredientRefs.cast<DocumentReference>());
    var availableDishes = await _getDishesFromReferences(dishRefs.cast<DocumentReference>());

    // Convert the objectives field from Firestore into Objective instances


    print('objectiveRefs');
    var objectiveRefs = doc.get('objectives').cast<DocumentReference>().toList();
    var objectives = await _getObjectivesFromReferences(objectiveRefs);

    // Get the data from the fetched documents
    // List<Objective> objectives = objectiveDocs.map((doc) => Objective.fromDocument(doc)).toList();

    // Construct and return the Level instance with the new objectives list
    return Level(
      levelNumber: doc.get('levelNumber') as int,
      guests: guests,
      availableIngredients: availableIngredients,
      availableDishes: availableDishes,
      educationalGoal: doc.get('educationalGoal') as String,
      objectives: objectives,
      unlocks: List<String>.from(doc.get('unlocks')),
    );
  }

  static Future<List<Guest>> _getGuestsFromReferences(List<DocumentReference> refs) async {
    List<Guest> guests = [];
    for (var ref in refs) {
      DocumentSnapshot<Object?> guestDoc = await ref.get();
      guests.add(Guest.fromDocument(guestDoc)); // Assuming Guest.fromDocument exists
    }
    return guests;
  }

  static Future<List<Ingredient>> _getIngredientsFromReferences(List<DocumentReference> refs) async {
    List<Ingredient> ingredients = [];
    for (var ref in refs) {
      DocumentSnapshot<Object?> ingredientDoc = await ref.get();
      ingredients.add(Ingredient.fromDocument(ingredientDoc)); // Ensure Ingredient.fromDocument exists
    }
    return ingredients;
  }

  static Future<List<Dish>> _getDishesFromReferences(List<DocumentReference> refs) async {
    List<Dish> dishes = [];
    for (var ref in refs) {
      DocumentSnapshot<Object?> dishDoc = await ref.get();
      dishes.add(await Dish.fromDocument(dishDoc)); // Assuming Dish has a compatible fromDocument factory constructor
    }
    return dishes;
  }

  static Future<List<Objective>> _getObjectivesFromReferences(List<DocumentReference> refs) async {
  List<Objective> objectives = [];
  for (var ref in refs) {
    DocumentSnapshot<Object?> objectiveDoc = await ref.get();
    objectives.add(Objective.fromDocument(objectiveDoc)); // Ensure Objective.fromDocument exists
  }
  return objectives;
}

}