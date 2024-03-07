import 'package:flutter/material.dart';
import 'package:food_waste_game/main.dart';
import 'package:food_waste_game/models/dish.dart';
import 'package:food_waste_game/models/level.dart';
import 'package:food_waste_game/screens/preparation_area.dart';
import 'package:food_waste_game/services/background_music_service.dart';
import 'package:food_waste_game/widgets/objective_tracker.dart';
import 'package:provider/provider.dart';
import '../state/game_state.dart';
import '../widgets/guest_profile_widget.dart';
import '../widgets/ingredient_widget.dart';
import '../widgets/waste_meter.dart';




void _showPauseMenu(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return _PauseMenu(); // This will display the pause menu
    },
  );
}

void showObjectiveDialogue(BuildContext context, objectives) {
  showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: Text('Current Level Objectives'),
    content: Container( // Ensure the container constrains the size of the ListView
      width: double.maxFinite, // or some fixed width if preferred
      child: ListView.builder(
        shrinkWrap: true, // Makes the ListView only occupy needed space
        itemCount: objectives.length,
        itemBuilder: (context, index) {
          final objective = objectives[index];
          return ListTile(
            leading: Icon(objective.isCompleted ? Icons.check_circle_outline : Icons.circle_outlined),
            title: Text(objective.description),
          );
        },
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text('Close'),
      ),
    ],
  ),
);
}



class GameScreen extends StatelessWidget {
  final Level level;

  GameScreen({Key? key, required this.level}) : super(key: key);

  // Method to simulate completing a level and updating the player level
  void _simulateLevelCompletion(BuildContext context) {
    final gameState = Provider.of<GameState>(context, listen: false);
    // Simulate achieving a new score (example: 150 points)
    gameState.updatePlayerLevelAndCheckUnlocks(150, context).then((_) {
      // Call onLevelComplete with context when the level is considered completed
      gameState.onLevelComplete(context);
    });
  }

  void _showAvailableDishes(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Consumer<GameState>(
          builder: (context, gameState, child) {
            List<Dish> dishesToShow; // Use List<Dish> to hold Dish objects

            if (gameState.currentPlayer == null) {
              // For non-signed-in users, show Level 1 dishes
              //dishesToShow = gameState.dishesForLevel(1); // Assuming this method filters _availableDishes by level
              dishesToShow = gameState.availableDishes;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Sign in to unlock more dishes!")));
                }
              });
            } else {
              // For signed-in users, show unlocked dishes
              // Map the unlocked dish names back to Dish objects
              dishesToShow = gameState.currentPlayer!.unlockedDishes
                  .map((name) => gameState.availableDishes.firstWhere((dish) => dish.name == name))
                  .toList();

              if (dishesToShow.isEmpty) {
                gameState.checkForUnlockedRecipes(gameState.currentPlayer!, context);
              }
            }

          return GridView.builder(
            padding: EdgeInsets.all(8),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: dishesToShow.length,
            itemBuilder: (context, index) {
              Dish dish = dishesToShow[index];
              return Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Image(
                        image: AssetImage(dish.imagePath), // Use AssetImage for the image provider
                        fit: BoxFit.contain,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(dish.name, style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    // You can add more details such as prep time or tags here
                  ],
                ),
              );
            },
          );
        },
      );
      },
    );
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Game Screen'), 
      leading: Builder( // Use a Builder to provide a context within the Scaffold
        builder: (BuildContext context) {
          return IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        },
        
      ),
      actions: [
        Consumer<GameState>( // Add Consumer here
          builder: (context, gameState, child) {
            return IconButton(
              icon: Icon(Icons.list_alt_outlined),
              onPressed: () {
                // Access the current game state to get the objectives
                final objectives = Provider.of<GameState>(context, listen: false).currentLevel?.objectives;
                if (objectives != null) {
                  showObjectiveDialogue(context, objectives);
                } else {
                  // Optionally handle the case where there are no objectives
                  print("No objectives to show.");
                }
              },
            );
          },
        ),
        IconButton(
          icon: Icon(Icons.star), // Example icon for simulating level completion
          onPressed: () => _simulateLevelCompletion(context),
        ),
        IconButton(
          icon: Icon(Icons.menu_book), // A book-like icon can represent recipes/dishes
          onPressed: () {
            _showAvailableDishes(context);
          },
        ),
        Consumer<GameState>(
          builder: (context, gameState, child) {
            return IconButton(
              icon: Icon(gameState.isPaused ? Icons.play_arrow : Icons.pause),
              onPressed: () {
                // Toggle game pause state
                if (gameState.isPaused) {
                  gameState.resumeGame();
                  //_PauseMenu();
                  Provider.of<BackgroundMusicService>(context, listen: false).resumeBackgroundMusic();
                } else {
                  gameState.pauseGame();
                  _showPauseMenu(context);
                  Provider.of<BackgroundMusicService>(context, listen: false).pauseBackgroundMusic();
                  //const SizedBox.shrink();
                }
              },
            );
          },
        ),
        IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            // Optionally pause the game before leaving the screen
            //Provider.of<GameState>(context, listen: false).pauseGame();
            //_PauseMenu();
            // Return to main menu
            Navigator.pushReplacementNamed(context, AppRoutes.mainMenu);
          },
        ),
      ],
    ),
    drawer: Consumer<GameState>(
      builder: (context, gameState, child) {
        return Drawer(
          child: ListView.builder(
            itemCount: gameState.currentGuests.length,
            itemBuilder: (context, index) => GuestProfileWidget(guest: gameState.currentGuests[index]),
          ),
        );
      },
    ),
    body: Stack(
  children: [
    // Background container with decoration
    Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/backgrounds/game-background.png'),
          fit: BoxFit.cover,
        ),
      ),
    ),
    // Consumer to build game elements based on GameState
    Consumer<GameState>(
      builder: (context, gameState, child) {
        return Column(
          children: [
            Expanded(
              flex: 3,
              child: Wrap(
                children: gameState.availableIngredients.map((ingredient) => IngredientWidget(ingredient)).toList(),
              ),
            ),
            PreparationArea(selectedIngredients: gameState.selectedIngredients),
            WasteMeter(wasteLevel: gameState.wasteAmount),
          ],
        );
      },
    ),
    // Positioned ObjectiveTracker without Flexible
    Positioned(
      top: 100,
      right: 20,
      child: ObjectiveTracker(),
    ),
  ],
),


  );
}

}


class _PauseMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,  
          children: [
            Text("Game Paused", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () { 
                Provider.of<GameState>(context, listen: false).resumeGame();
                Provider.of<BackgroundMusicService>(context, listen:false).resumeBackgroundMusic();
                Navigator.pop(context);
              },
              child: Text("Resume"),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(104, 175, 226, 100),
                  foregroundColor: Colors.white,
                  ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () { 
                // Pause, then go to main menu 
                Provider.of<GameState>(context, listen: false).pauseGame();
                //_PauseMenu();
                Navigator.pushReplacementNamed(context, AppRoutes.mainMenu); 
              },
              child: Text("Exit to Main Menu"),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(104, 175, 226, 100),
                  foregroundColor: Colors.white,
                  ),
            ), 
          ],
        ),
      ),
    );
  }

  

}