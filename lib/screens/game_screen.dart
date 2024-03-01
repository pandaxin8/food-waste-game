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
  void _showAvailableDishes(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        // You could use Consumer<GameState> here if your available dishes are part of your game state.
        return Consumer<GameState>(
          builder: (context, gameState, child) {
            return ListView.builder(
              itemCount: gameState.availableDishes.length,
              itemBuilder: (context, index) {
                Dish dish = gameState.availableDishes[index];
                return ListTile(
                  title: Text(dish.name),
                  // Add more info about the dish here if necessary
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
      body: Consumer<GameState>(
        builder: (context, gameState, child) {
          return Column(
            children: [
              // Expanded(
              //   flex: 2,
              //   child: ShaderMask(
              //     shaderCallback: (Rect bounds) {
              //       return LinearGradient(
              //         begin: Alignment.topCenter,
              //         end: Alignment.bottomCenter,
              //         colors: [Colors.white, Colors.transparent, Colors.transparent, Colors.white],
              //         stops: [0.0, 0.1, 0.9, 1.0],
              //       ).createShader(bounds);
              //     },
              //     blendMode: BlendMode.dstOut,
              //     child: 
                  // Scrollbar(
                   // isAlwaysShown: true,
                    // child: ListView.builder(
                    //   itemCount: gameState.currentGuests.length,
                    //   itemBuilder: (context, index) => GuestProfileWidget(guest: gameState.currentGuests[index]),
                    // ),
                  // ),
                // ),
              // ),
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
    );
  }
}