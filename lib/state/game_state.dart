import 'package:flutter/material.dart';
import 'package:food_waste_game/services/data_service.dart';
import 'package:provider/provider.dart'; 
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
  List<Dish> get availableDishes => _availableDishes;

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

  void submitDish(List<Ingredient> selectedIngredients, BuildContext context) {
    // Check if the selected ingredients can form a valid dish.
    if (Dish.canFormDish(selectedIngredients)) {
      print('submitDish: can form a valid dish');
      // If they can, create the dish and check against the guest's preferences.
      Dish dish = Dish(
        name: 'Custom Dish', // You might want to generate a name based on ingredients.
        ingredients: selectedIngredients,
        prepTime: 10, // Placeholder value for prepTime.
        satisfiesTags: calculateSatisfiesTags(selectedIngredients),
      );

      // Check if the created dish satisfies the current guest's preferences.
      // Assuming one guest for MVP. Update logic for multiple guests.
      Guest currentGuest = _currentGuests.first;
      bool dishMatched = currentGuest.isSatisfiedBy(dish);

      if (dishMatched) {
        _score += 20; // Increment the score.
        _showFeedback('Delicious! The guest loved it!', context);
      } else {
        _wasteAmount += 10; // Increment the waste amount.
        _showFeedback('Oh no! The guest did not like it.', context);
      }

      // Clear the selected ingredients after submission.
      selectedIngredients.clear();
      print('selectedIngredients cleared');
    } else {
      _showFeedback('This combination doesn\'t make a dish.', context);
    }

    notifyListeners(); // Notify UI to rebuild.
  }

  // Helper function to calculate the list of tags based on selected ingredients.
  List<String> calculateSatisfiesTags(List<Ingredient> ingredients) {
    // This will create a list of unique dietary tags from the selected ingredients.
    return ingredients.expand((ingredient) => ingredient.dietaryTags).toSet().toList();
  }

  String generateFeedbackForDish(Dish dish, Guest guest) {
    // Here, you would compare dish.ingredients with guest.dietaryRestrictions and guest.preferences
    // Then, construct a feedback message based on how well they match
    // This is a placeholder function for now
    if (dish.doesSatisfyDietaryRestrictions(guest)) {
      return 'Perfect match! You\'ve satisfied the guest\'s preferences.';
    } else {
      return 'Not quite right. Try these ingredients: ${guest.preferences.join(", ")}';
    }
  }

  void _loadLevel(int levelNumber) {
    // ... logic to fetch level data (guests, ingredients) based on levelNumber
    // ... update _currentGuests and _availableIngredients 
    notifyListeners(); 
  }


  // ... more methods as game mechanics evolve (e.g. ending level, changing ingredients based on dish usage, etc.)
}