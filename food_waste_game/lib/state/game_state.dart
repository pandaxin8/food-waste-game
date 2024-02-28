import 'package:flutter/material.dart'; 
import '../models/ingredient.dart';
import '../models/guest.dart';
import '../models/dish.dart';

class GameState with ChangeNotifier {
  int _score = 0;
  int _wasteAmount = 0;
  int _currentLevel = 1;
  List<Ingredient> _availableIngredients = [];
  List<Guest> _currentGuests = [];

  // constructor to initialise with sample data 
  GameState() {
    // load data from local storage or an external source eventually
    // ... for now, we'll initialise with some basic sample data
    _availableIngredients = [
      Ingredient(name: 'Tomato', imageUrl: '...', dietaryTags: ['vegetarian'], calories: 20),
      Ingredient(name: 'Lettuce', imageUrl: '...', dietaryTags: ['vegetarian', 'vegan'], calories: 10),
      // ... more ingredients here
    ];
    _currentGuests = [
      Guest(name: 'Alice', preferenceIcon: '...', dietaryRestrictions: ['gluten-free'], maxCalories: 500)
      // ... more guests here
    ];
  }

  // accessors - getters
  int get score => _score;
  int get wasteAmount => _wasteAmount;
  int get currentLevel => _currentLevel;
  List<Ingredient> get availableIngredients => _availableIngredients;  
  List<Guest> get currentGuests => _currentGuests;

  // methods to modify the state

  void startNewGame() {
    _score = 0;
    _wasteAmount = 0;
    _currentLevel = 1;
    _loadLevel(_currentLevel); // Fetch level data
  }

  void submitDish(Dish dish) {
    // 1. check if the dish matches any current guest's needs
    // 2. calculate score impact (positive or negative)
    // 3. calculate waste amount
    // 4. update _score and _wasteAmount
    bool dishMatched = false;
    for (Guest guest in _currentGuests) {
      if (guest.isSatisfiedBy(dish)) {
        _score += 20; // Example positive score
        dishMatched = true;
        break; // assuming the dish is meant for a single guest
      }
    }

    if (!dishMatched) {
      _wasteAmount += 10; // example penalty
    }

    notifyListeners(); // notify UI to rebuild
  }

  void _loadLevel(int levelNumber) {
    // ... logic to fetch level data (guests, ingredients) based on levelNumber
    // ... update _currentGuests and _availableIngredients 
    notifyListeners(); 
  }

  // ... more methods as game mechanics evolve (e.g. ending level, changing ingredients based on dish usage, etc.)
}