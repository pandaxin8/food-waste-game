import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_waste_game/models/level.dart';
import 'package:food_waste_game/models/objective.dart';
import 'package:food_waste_game/models/player.dart';
import 'package:food_waste_game/models/unlock-notification.dart';
import 'package:food_waste_game/screens/game_screen.dart';
import 'package:food_waste_game/screens/level_summary_screen.dart';
import 'package:food_waste_game/services/data_service.dart';
import 'package:food_waste_game/widgets/notification_widget.dart';
import 'package:provider/provider.dart';
import '../models/ingredient.dart';
import '../models/guest.dart';
import '../models/dish.dart';






class GameState with ChangeNotifier {
  int _score = 0;
  int _wasteAmount = 0;
  List<Ingredient> _availableIngredients = [];
  List<Guest> _currentGuests = [];
  List<Dish> _availableDishes = [];
  bool _isPaused = false;
  bool get isPaused => _isPaused;

  final DataService _dataService = DataService();

  Player? currentPlayer; // hold the current player's data

  Level? currentLevel;
  int _currentLevel = 1;

  List<Ingredient> _selectedIngredients = [];

  List<Dish> _madeDishes = [];


  Future<void> _loadInitialData() async {
    try {
      loadCurrentPlayerData();
      print('currentPlayer: $currentPlayer');
      _availableIngredients = await _dataService.getIngredients(); 
      print('Ingredients fetched: $_availableIngredients');
      // ... Potentially load guests here too: _currentGuests = await _dataService.getGuests();
      _currentGuests = await _dataService.getGuests();
      print('Guests fetched: $_currentGuests');
      // _availableDishes = await _dataService.getDishes();
      // print('Dishes fetched: $_availableDishes');
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
  List<Ingredient> get availableIngredients => _availableIngredients;  
  List<Guest> get currentGuests => _currentGuests;
  List<Dish> get availableDishes => _availableDishes;
  Level? get currentLevelObject => currentLevel;
  List<Ingredient> get selectedIngredients => _selectedIngredients;
  List<Dish> get madeDishes => _madeDishes;
  
  

  // methods to modify the state


  Future<void> startNewGame(BuildContext context) async {
    _score = 0;
    _wasteAmount = 0;
    await loadLevel(_currentLevel);
    // showLevelStartModal(context);
    _availableDishes = await _dataService.getDishesForLevel(_currentLevel);
    notifyListeners();
    
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
    // 1. Filter for Selected Ingredients:
    final ingredientsForDish = selectedIngredients.where((ingredient) => ingredient.isSelected).toList();

    // 1. Find Unselected Ingredients in Preparation Area:
    final unselectedIngredients = selectedIngredients.where((ingredient) => !ingredient.isSelected).toList(); 

  // 2. Handle the unselected ingredients (you have options):
    // Option A: Directly penalize waste
      // _wasteAmount += calculateWastePenalty(unselectedIngredients); // You'll need to define how the penalty is calculated

    // Check if any ingredients remain (in case none were selected):
    if(ingredientsForDish.isEmpty) {
      _showFeedback('Please select some ingredients before cooking', context);
      return; // Early exit if no ingredients were selected
    }
    // Check if the selected ingredients can form a valid dish.
    if (canFormDish(ingredientsForDish)) {
      print('submitDish: can form a valid dish');
      // If they can, create the dish and check against the guest's preferences.
      // Dish dish = Dish(
      //   name: 'Custom Dish', // You might want to generate a name based on ingredients.
      //   ingredients: ingredientsForDish,
      //   prepTime: 10, // Placeholder value for prepTime.
      //   satisfiesTags: calculateSatisfiesTags(ingredientsForDish),
      //   unlockLevel: 1,
      //   imagePath: '',
      // );
      Dish dish = findClosestRecipeMatch(context, selectedIngredients);

      // Check if the created dish satisfies the current guest's preferences.
      // Assuming one guest for MVP. Update logic for multiple guests.
      Guest currentGuest = _currentGuests.first;
      bool dishMatched = currentGuest.isSatisfiedBy(dish);

      if (dishMatched) {
        _score += 20; // Increment the score.
        _showFeedback('Delicious! The guest loved it!', context);
        currentGuest.isSatisfied = true;

        // Add the dish to the list of made dishes
        _madeDishes.add(dish);
      } else {
        _wasteAmount += 10; // Increment the waste amount.
        _showFeedback('Oh no! The guest did not like it.', context);
      }

      // Clear the selected ingredients after submission.
      print('selectedIngredients cleared');
    } else {
      // _showFeedback('This combination doesn\'t make a dish.', context);
      // Provide a hint about what dish they might have been trying to make
      Dish closestMatch = findClosestRecipeMatch(context, selectedIngredients);
      _showFeedback('Almost! Did you mean to make a ${closestMatch.name}?', context);
    }

    checkObjective2Completion(ingredientsForDish); // Check after dish creation
    deselectIngredients(ingredientsForDish);
    ingredientsForDish.clear();

    if (unselectedIngredients.isNotEmpty) {
      String wastedIngredientsList = unselectedIngredients.map((ingredient) => ingredient.name).join(', '); // Build a comma-separated list of wasted ingredients
      _showFeedback("These ingredients went to waste: $wastedIngredientsList", context);
      _wasteAmount += 10 * unselectedIngredients.length;
    }

    print('currentGuests: $currentGuests');

    for (int i = 0; i < currentGuests.length; i++) { 
    Guest guest = currentGuests[i];
    // if (guest.isSatisfied) continue; // Skip already satisfied guests

    if (guest.isSatisfied) {
      print('guest is satisfied');
      
      // Remove the satisfied guest (assuming simple removal from the top is desired)
      currentGuests.removeAt(i); 

      notifyListeners(); // Notify listeners to update the UI 
      break; // Stop checking guests if one is satisfied
    }
  }


    notifyListeners(); // Notify UI to rebuild.
    
  }



  void resetLevelState() {
    _madeDishes.clear();
    // Reset other necessary properties for a new level
  }

  void deselectIngredients(List<Ingredient> ingredients) {
    for (Ingredient ingredient in ingredients) {
      final matchingIngredient = availableIngredients.firstWhere((i) => i.name == ingredient.name);
      matchingIngredient.isSelected = false; 
    }
  }

  // Helper method to find the closest recipe match based on selected ingredients
  Dish findClosestRecipeMatch(BuildContext context, List<Ingredient> selectedIngredients) {
    // Implement logic to find the closest matching recipe
    // This could be based on the number of matching ingredients
    // ...
    Dish? closestMatch;
    int highestMatchCount = 0;

    // Go through each available dish to compare ingredients
    for (var dish in _availableDishes) {
      // Count how many ingredients from the dish match the selected ingredients
      var matchCount = dish.ingredients.where((ingredient) =>
        selectedIngredients.any((selected) => selected.name == ingredient.name)
      ).length;

      // If the current dish has more matches than the previous highest, update closestMatch
      if (matchCount > highestMatchCount) {
        highestMatchCount = matchCount;
        closestMatch = dish;
      }
    }

    // Return the dish with the most matches (or an empty dish if none match)
    return closestMatch ?? Provider.of<GameState>(context, listen: false).availableDishes.first;;
  }


  // Check if the selected ingredients form a valid dish.
  bool canFormDish(List<Ingredient> selectedIngredients) {
    for (var dish in _availableDishes) {
      var recipeIngredients = dish.ingredients.map((i) => i.name).toSet();
      var selectedIngredientsNames = selectedIngredients.map((i) => i.name).toSet();
      
      // Check if the selected ingredients match the recipe exactly
      if (recipeIngredients.difference(selectedIngredientsNames).isEmpty &&
          selectedIngredientsNames.difference(recipeIngredients).isEmpty) {
        return true;
      }
    }
    return false;
  }

  // This function would be called when the player unlocks a new recipe or achieves a new level
  Future<void> updatePlayerData(Player player) async {
    await FirebaseFirestore.instance.collection('players').doc(player.id).update(player.toMap());
  }

  // Future<void> createNewPlayer(User user) async {
  //   Player newPlayer = Player(id: user.uid); // Using Firebase Auth UID
  //   await FirebaseFirestore.instance.collection('players').doc(newPlayer.id).set(newPlayer.toMap());
  // }

  Future<void> createNewPlayerProfile() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Player newPlayer = Player(
        id: user.uid,
        currentLevel: 1,
        unlockedDishes: [],
        // ... any other initial fields
      );
      await FirebaseFirestore.instance.collection('players').doc(user.uid).set(newPlayer.toMap());
    } else {
      // Handle the user not being signed in
    }
  }


  Future<Player?> loadPlayerData(String userId) async {
    DocumentSnapshot playerDoc = await FirebaseFirestore.instance.collection('players').doc(userId).get();
    if (playerDoc.exists) {
      return Player.fromDocument(playerDoc);
    }
    return null;
  }

    // Method to check for unlocked recipes and provide feedback
    Future<void> checkForUnlockedRecipes(Player player, BuildContext context) async {
      // Assume _dataService.getDishes() fetches all available dishes, including their unlock levels
      List<Dish> allDishes = await _dataService.getDishes();
      List<String> newlyUnlockedDishes = [];

      for (Dish dish in allDishes) {
        if (player.currentLevel >= dish.unlockLevel && !player.unlockedDishes.contains(dish.name)) {
          print(dish.unlockLevel);
          newlyUnlockedDishes.add(dish.name);
          player.unlockedDishes.add(dish.name); // Update the player's unlocked dishes list
        }
      }

      if (newlyUnlockedDishes.isNotEmpty) {
        // Save the updated player data
        await updatePlayerData(player);

        // Provide feedback for each newly unlocked dish
        newlyUnlockedDishes.forEach((dishName) {
          // Note: You need to ensure that you have access to a BuildContext for showing SnackBars.
          // This example assumes _showFeedback is called in a context where ScaffoldMessenger.of(context) is accessible.
          _showFeedback('New recipe unlocked: $dishName!', context);
        });
      }
    }

    // Example method to get dishes for a given level
  List<Dish> dishesForLevel(int level) {
    // This could be replaced with a database query in a real app
    print('level $level');
    return _availableDishes.where((dish) => dish.unlockLevel <= level).toList();
  }

  // Use this method to decide which dishes to show
  List<Dish> get dishesToShow {
    if (currentPlayer == null) {
      // If no player is logged in, show Level 1 dishes by default
      return dishesForLevel(1);
    } else {
      // If a player is logged in, show dishes unlocked for their level
      return getUnlockedDishes(currentPlayer!);
    }
  }

  // Example implementation for getUnlockedDishes assuming currentPlayer is properly managed
  List<Dish> getUnlockedDishes(Player player) {
    // This needs to match your logic for storing and identifying unlocked dishes
    // For simplicity, assuming unlockedDishes are stored as dish names in the Player model
    return _availableDishes.where((dish) => player.unlockedDishes.contains(dish.name)).toList();
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

  Future<Player?> loadCurrentPlayer() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot playerDoc = await FirebaseFirestore.instance.collection('players').doc(user.uid).get();
      if (playerDoc.exists) {
        return Player.fromDocument(playerDoc);
      }
    }
    return null;
  }



  Future<void> loadCurrentPlayerData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var playerDoc = await FirebaseFirestore.instance.collection('players').doc(user.uid).get();
      if (playerDoc.exists) {
        print("Player Data: ${playerDoc.data()}");
        currentPlayer = Player.fromDocument(playerDoc);
        print("Current Player Loaded: ${currentPlayer?.id}");
      } else {
        print("No player data found for user ID: ${user.uid}");
      }
    } else {
      print("Cannot load player data. No user is currently logged in.");
    }
  }


  Future<void> _createNewPlayerProfile(User user) async {
    // Initialize player data with default values or based on any initial input you might have
    Player newPlayer = Player(
      id: user.uid,
      currentLevel: 1,
      points: 0,
      unlockedDishes: [],
      achievements: [],
      // Add other fields as necessary
    );

    // Save the new player profile to Firestore
    await FirebaseFirestore.instance.collection('players').doc(user.uid).set(newPlayer.toMap());

    // Update the currentPlayer with the new profile
    currentPlayer = newPlayer;
    notifyListeners(); // Notify listeners to update UI based on the new player data
  }


  // Example method to update player level and check for recipe unlocks
Future<void> updatePlayerLevelAndCheckUnlocks(int newScore, BuildContext context) async {
    Player? currentPlayer = await loadCurrentPlayer();
    if (currentPlayer != null) {
      // Example logic to update level based on score. Adjust according to your game's logic.
      int newLevel = currentPlayer.currentLevel + (newScore ~/ 100); // Simplified progression logic.
      currentPlayer.currentLevel = newLevel;

      // Update player data with the new level
      await updatePlayerData(currentPlayer);

      // After updating the level, check for any recipes that should now be unlocked
      await checkForUnlockedRecipes(currentPlayer, context);
    }
  }


  Future<void> loadLevel(int levelNumber) async { // Change return type to Future<void>
    DocumentSnapshot levelDoc = await FirebaseFirestore.instance.collection('levels').doc('level-$levelNumber').get();
    if (levelDoc.exists) {
      currentLevel = await Level.fromDocument(levelDoc); 
      print('currentLevel: ${currentLevel!.levelNumber}');
      notifyListeners();
      print('level doc exists');
    } else {
      // Handle the case where the level does not exist.
      print('level doc doesn\'t exists');
    }
  }

  // This method will check if the objectives for the current level have been completed.
  bool checkIfObjectivesCompleted() {
    if (currentLevel == null) {
      return false; // or handle this case appropriately
    }

    // Check if all objectives are completed
    return currentLevel!.objectives.every((objective) => objective.isCompleted);
  }

  void onLevelComplete(BuildContext context) {
    if (currentLevel == null) {
      print('Error: No current level data.');
      return; // Handle this case as needed
    }

    // Check if all objectives for the level are completed
    if (checkIfObjectivesCompleted()) {
      // Navigate to the Level Summary Screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LevelSummaryScreen(gameState: this),
        ),
      );
    } else {
      print('The level is not yet completed.');
    }
  }


  void onPlayerAction(BuildContext context) {
    // Player performs an action, e.g., placing an ingredient, completing a dish, etc.

    // ... actions take place ...

    // Now check if the action completed the level
    bool levelIsComplete = checkIfObjectivesCompleted();
    if (levelIsComplete) {
      onLevelComplete(context);
    }
  }


  // void performActionThatCompletesObjective(BuildContext context, Objective objective) {
  //   // If the objective is not already completed, complete it
  //   if (!objective.isCompleted) {
  //     objective.complete();

  //     // Check if all objectives are now completed
  //     if (checkIfObjectivesCompleted()) {
  //       onLevelComplete(context);
  //     }
  //     notifyListeners();
  //   }
  // }

  // Method to unlock rewards
  void unlockLevelRewards(BuildContext context) {
    // Use a null check before trying to access the `unlocks` property
    print('currentLevel: ${currentLevel!.levelNumber}');
    if (currentLevel != null) {
      // Assuming `unlocks` is a list of strings describing what has been unlocked
      for (String unlock in currentLevel!.unlocks) { // Use the null assertion operator '!' after null checking
        // Create a notification for each unlock
        UnlockNotification notification = UnlockNotification(
          'Congratulations!', // Customize this title
          'You have unlocked: $unlock', // The message showing what has been unlocked
          Icons.star, // Choose an icon that makes sense for your reward
        );

        // Show the notification
        showUnlockNotification(context, notification);
      }

      for (Dish dish in currentLevel!.newDishes) { // Use the null assertion operator '!' after null checking
        // Create a notification for each unlock
        UnlockNotification notification = UnlockNotification(
          'Congratulations!', // Customize this title
          'You have unlocked: ${dish.name}', // The message showing what has been unlocked
          dish.imagePath, // Choose an icon that makes sense for your reward
        );

        // Show the notification
        showUnlockNotification(context, notification);
      }

      
    
      // ... Your logic for actually unlocking the rewards ...
    } else {
      // Handle the case where `currentLevel` is null
      // You could show an error or log this situation as it should not happen in normal game flow
    }
  }


  // Method to advance to the next level
  Future<void> advanceToNextLevel(BuildContext context) async {
    _currentLevel++;
    try {
      DocumentSnapshot levelDoc = await FirebaseFirestore.instance
          .collection('levels')
          .doc('level-$_currentLevel')
          .get();

      if (levelDoc.exists) {
        currentLevel = await Level.fromDocument(levelDoc);
        _availableDishes = await _dataService.getDishesForLevel(_currentLevel);
        notifyListeners();
        
        if (currentLevel != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => GameScreen(level: currentLevel!),
            ),
          );
        } else {
          print('current level is null');
        }
      } 
    } catch (e) {
      print('Error advancing to next level: $e');
    }
  }




    // void showLevelStartModal(BuildContext context) {
    //   showDialog(
    //     context: context,
    //     barrierDismissible: false, // Prevent closing the modal by tapping outside
    //     builder: (BuildContext context) {
    //       return AlertDialog(
    //         title: const Text('Level Objectives'),
    //         content: Column(
    //           mainAxisSize: MainAxisSize.min, // Important for scrollable objectives
    //           children: [
    //             // Display the objectives here (more on this later)
    //           ],
    //         ),
    //         actions: [
    //           TextButton(
    //             onPressed: () {
    //               Navigator.of(context).pop(); // Dismiss the modal
    //             },
    //             child: Text('Got it!'),
    //           ),
    //         ],
    //       );
    //     },
    //   );
    // }

    void checkObjective1Completion(List<Ingredient> selectedIngredients) {
      print('checking objective completion');
      // Objective 1: Select Tomato and Spinach...
      print('current level objectives:');
      print(currentLevel!.objectives);
      final objective1 = currentLevel!.objectives.firstWhere((obj) => obj.id == "1-1");
      if (availableIngredients.any((ingredient) => ingredient.name == 'Tomato' && ingredient.isSelected) && availableIngredients.any((ingredient) => ingredient.name == 'Spinach' && ingredient.isSelected)) {
        objective1.complete();
      }
      print(objective1.isCompleted);

      notifyListeners();
    }

    // Objective 2: Combine selected ingredients...
    void checkObjective2Completion(List<Ingredient> selectedIngredients) {
      final objective2 = currentLevel!.objectives.firstWhere((obj) => obj.id == "1-2");
      if (_selectedIngredients.any((ingredient) => ingredient.name == 'Tomato') &&
          _selectedIngredients.any((ingredient) => ingredient.name == 'Spinach') && _selectedIngredients.length == 2) {
        objective2.complete();
      }
      print(objective2.isCompleted);

      // Notify UI if there were changes:
      notifyListeners();

    }

  void showUnlockNotification(BuildContext context, UnlockNotification notification) {
    showDialog(
      context: context,
      builder: (BuildContext context) => UnlockNotificationWidget(notification: notification),
    );
  }

  void incrementWaste(Ingredient ingredient) {
    // Increment the waste count here.
    // You might want to check if the ingredient is already in the waste to avoid duplicates.
    _wasteAmount += 10;
    notifyListeners();
  }




  // ... more methods as game mechanics evolve (e.g. ending level, changing ingredients based on dish usage, etc.)
}