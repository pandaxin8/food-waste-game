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
}