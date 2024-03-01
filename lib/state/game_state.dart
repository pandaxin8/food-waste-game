import 'package:flutter/material.dart';
import 'package:food_waste_game/services/data_service.dart'; 
import '../models/ingredient.dart';
import '../models/guest.dart';
import '../models/dish.dart';

class GameState with ChangeNotifier {
  int _score = 0;
  int _wasteAmount = 0;
  int _currentLevel = 1;
  List<Ingredient> _availableIngredients = [];
  List<Guest> _currentGuests = [];
  List<Dish> _availableDishes = [];
  bool _isPaused = false;
  bool get isPaused => _isPaused;

  final DataService _dataService = DataService();

  Future<void> _loadInitialData() async {
    try {
      _availableIngredients = await _dataService.getIngredients(); 
      print('Ingredients fetched: $_availableIngredients');
      // ... Potentially load guests here too: _currentGuests = await _dataService.getGuests();
      _currentGuests = await _dataService.getGuests();
      print('Guests fetched: $_currentGuests');
      _availableDishes = await _dataService.getDishes();
      print('Dishes fetched: $_availableDishes');
      notifyListeners();
    } catch (error) {
      print('Error loading initial data: $error');
    }
  }

  // constructor to initialise with sample data 
  GameState() {
    _loadInitialData(); 
    // load data from local storage or an external source eventually
    // ... for now, we'll initialise with some basic sample data
    _availableIngredients = [
      //Ingredient(name: 'Tomato', imageUrl: 'assets/images/ingredients/tomato.png', dietaryTags: ['vegetarian'], calories: 20),
      //Ingredient(name: 'Cucumber', imageUrl: 'assets/images/ingredients/cucumber.png', dietaryTags: ['vegetarian', 'vegan'], calories: 15),
      // ... more ingredients here
    ];
    _currentGuests = [
      //Guest(name: 'Alice', iconUrl: 'assets/images/characters/cat-sprite.png', preferences: ['vegetarian'], dietaryRestrictions: ['gluten-free'], maxCalories: 500),
      //Guest(name: 'Bob', iconUrl: 'assets/images/characters/chef-cat-1.png', preferences: ['vegan'], dietaryRestrictions: ['no-tomato'], maxCalories: 500),
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

  // Simple feedback display (also in GameState)
  void _showFeedback(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));  
  }

  void pauseGame() {
    _isPaused = true;
    // Pause timers, animations, etc.
    notifyListeners();
  }

  void resumeGame() {
    _isPaused = false;
    // Resume timers, animations, etc.
    notifyListeners();
  }

  void submitDish(Dish dish, BuildContext context) {
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

    // Feedback (inside GameState, assuming track if a dish was matched)
    if (dishMatched) {
      _showFeedback('Correct!', context); 
    } else {
      _showFeedback('Try Again!', context);
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