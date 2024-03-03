import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_waste_game/main.dart';
import 'package:food_waste_game/models/dish.dart';
import 'package:food_waste_game/screens/preparation_area.dart';
import 'package:provider/provider.dart';
import '../state/game_state.dart';
import '../widgets/guest_profile_widget.dart';
import '../widgets/ingredient_widget.dart';
import '../widgets/waste_meter.dart';




class GameScreen extends StatelessWidget {
  // Method to simulate completing a level and updating the player level
  void _simulateLevelCompletion(BuildContext context) {
    final gameState = Provider.of<GameState>(context, listen: false);
    // Simulate achieving a new score (example: 150 points)
    gameState.loadCurrentPlayerData();
    gameState.updatePlayerLevelAndCheckUnlocks(150, context).then((_) {
      // After updating, you might want to refresh certain parts of your UI or show a confirmation message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Level completed! Checking for new recipes...')));
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
              dishesToShow = gameState.dishesForLevel(1); // Assuming this method filters _availableDishes by level
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

              if (dishesToShow.length == 0) {
                gameState.checkForUnlockedRecipes(gameState.currentPlayer!, context);
              }
            }

            // Display the dishes
            return ListView.builder(
              itemCount: dishesToShow.length,
              itemBuilder: (context, index) {
                Dish dish = dishesToShow[index];
                return ListTile(
                  title: Text(dish.name),
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
            icon: Icon(Icons.person), // TODO: replace with guest-related icon
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        },
      ),
      actions: [
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
                } else {
                  gameState.pauseGame();
                }
              },
            );
          },
        ),
        IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            // Optionally pause the game before leaving the screen
            Provider.of<GameState>(context, listen: false).pauseGame();
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
    body: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('/images/backgrounds/game-background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Consumer<GameState>(
        builder: (context, gameState, child) {
          return Column(
            children: [
              Expanded(
                flex: 3,
                child: Wrap(
                  children: gameState.availableIngredients.map((ingredient) => IngredientWidget(ingredient)).toList(),
                ),
              ),
              PreparationArea(),
              WasteMeter(wasteLevel: gameState.wasteAmount),
            ],
          );
        },
      ),
    ),
  );
}


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Game Screen'), 
//         leading: Builder( // Use a Builder to provide a context within the Scaffold
//         builder: (BuildContext context) {
//           return IconButton(
//             icon: Icon(Icons.person), // TODO: replace with guest-related icon
//             onPressed: () {
//               Scaffold.of(context).openDrawer();
//             },
//           );
//         },
//       ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.star), // Example icon for simulating level completion
//             onPressed: () => _simulateLevelCompletion(context),
//           ),
//           IconButton(
//             icon: Icon(Icons.menu_book), // A book-like icon can represent recipes/dishes
//             onPressed: () {
//               _showAvailableDishes(context);
//             },
//           ),
//           Consumer<GameState>(
//             builder: (context, gameState, child) {
//               return IconButton(
//                 icon: Icon(gameState.isPaused ? Icons.play_arrow : Icons.pause),
//                 onPressed: () {
//                   // Toggle game pause state
//                   if (gameState.isPaused) {
//                     gameState.resumeGame();
//                   } else {
//                     gameState.pauseGame();
//                   }
//                 },
//               );
//             },
//           ),
//           IconButton(
//             icon: Icon(Icons.home),
//             onPressed: () {
//               // Optionally pause the game before leaving the screen
//               Provider.of<GameState>(context, listen: false).pauseGame();
//               // Return to main menu
//               Navigator.pushReplacementNamed(context, AppRoutes.mainMenu);
//             },
//           ),
//         ],
//       ),
//       drawer: Consumer<GameState>(
//         builder: (context, gameState, child) {
//           return Drawer(
//             child: ListView.builder(
//               itemCount: gameState.currentGuests.length,
//               itemBuilder: (context, index) => GuestProfileWidget(guest: gameState.currentGuests[index]),
//             ),
//           );
//         },
//       ),
//       body: Consumer<GameState>(
//         builder: (context, gameState, child) {
//           return Column(
//             children: [
//               Expanded(
//                 flex: 3,
//                 child: Wrap(
//                   children: gameState.availableIngredients.map((ingredient) => IngredientWidget(ingredient)).toList(),
//                 ),
//               ),
//               PreparationArea(),
//               WasteMeter(wasteLevel: gameState.wasteAmount),
//             ],
//           );
//         },
//       ),
//     );
//   }
}