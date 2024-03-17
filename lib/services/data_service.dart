import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_waste_game/models/dish.dart';
import 'package:food_waste_game/models/guest.dart';
import 'package:food_waste_game/models/ingredient.dart';


class DataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Guest>> getGuests() async {
    CollectionReference guestsRef = _firestore.collection('guests');
    QuerySnapshot snapshot = await guestsRef.get(); 
    return snapshot.docs.map((doc) => Guest.fromDocument(doc)).toList(); 
  }

  Future<List<Guest>> getGuestsForLevel(int level) async {
    DocumentReference levelRef = _firestore.collection('levels').doc('level-$level');
    DocumentSnapshot levelSnapshot = await levelRef.get();

    // Check if the document exists and cast the data to Map<String, dynamic>
    if (!levelSnapshot.exists) {
      throw Exception('Level document does not exist.');
    }

    // Cast the data of the document snapshot to Map<String, dynamic>
    var levelData = levelSnapshot.data() as Map<String, dynamic>?;
    
    // Check if levelData is null or guests field does not exist
    if (levelData == null || !levelData.containsKey('guests')) {
      throw Exception('Guests field is missing or null.');
    }

    // Cast the guests field to List<dynamic> and check for null
    List<dynamic>? guestRefs = levelData['guests'] as List<dynamic>?;
    
    // If guestRefs is null, return an empty list
    if (guestRefs == null) {
      return [];
    }

    List<Future<Guest>> guestFutures = guestRefs.map((guestRef) {
      DocumentReference guestDocRef = guestRef as DocumentReference;
      return guestDocRef.get().then((docSnapshot) {
        if (!docSnapshot.exists) {
          throw Exception('Referenced guest document does not exist.');
        }
        return Guest.fromDocument(docSnapshot);
      });
    }).toList();

    List<Guest> guests = await Future.wait(guestFutures);
    return guests;
  }

  // ... Similar functions for getIngredients(), getDishes()
  Future<List<Ingredient>> getIngredients() async {
    CollectionReference ingredientsRef = _firestore.collection('ingredients');
    QuerySnapshot snapshot = await ingredientsRef.get();
    return snapshot.docs.map((doc) => Ingredient.fromDocument(doc)).toList();
  }

  Future<List<Dish>> getDishes() async {
    CollectionReference dishesRef = _firestore.collection('dishes');
    QuerySnapshot snapshot = await dishesRef.get();

    // Create a list of futures from the documents
    List<Future<Dish>> dishFutures = snapshot.docs.map((doc) async => await Dish.fromDocument(doc)).toList();

    // Wait for all futures to complete and return the resulting list
    List<Dish> dishes = await Future.wait(dishFutures);
    return dishes;
}

  Future<List<Dish>> getDishesForLevel(int level) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('dishes')
        .where('unlockLevel', isLessThanOrEqualTo: level)
        .get();

    // Create a list of futures by mapping over the snapshot.docs
    // and calling fromDocument for each doc, which returns a Future<Dish>
    var futures = snapshot.docs.map((doc) => Dish.fromDocument(doc)).toList();

    // Use Future.wait to wait for all futures in the list to complete
    // and return their results as a List<Dish>
    List<Dish> dishes = await Future.wait(futures);

    return dishes;
  }


}