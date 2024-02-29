import 'package:flutter/material.dart';
import 'package:food_waste_game/main.dart';
import 'package:food_waste_game/screens/preparation_area.dart';
import 'package:provider/provider.dart';
import '../state/game_state.dart';
import '../widgets/guest_profile_widget.dart';
import '../widgets/ingredient_widget.dart';
import '../widgets/waste_meter.dart';


class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game Screen'), 
        actions: [
          IconButton(
            icon: Icon(Icons.pause),
            onPressed: () {
              // ... Handle pausing the game ...
            },
          ),
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
             // ... Return to main menu ... 
             Navigator.pushReplacementNamed(context, AppRoutes.mainMenu);
            },
          )
        ],
        // title: Consumer<GameState>( // Update app bar elements dynamically
        //   builder: (context, gameState, child) {
        //     return Text('Score: ${gameState.score} - Level: ${gameState.currentLevel}'); 
        //   },
        // ),
      ),
      body: Consumer<GameState>(
        builder: (context, gameState, child) {
          return Column(
            children: [
              Expanded( // Guest Profiles
                flex: 2, // give more space to the guests
                child: ListView.builder(
                  itemCount: gameState.currentGuests.length,
                  itemBuilder: (context, index) => GuestProfileWidget(guest: gameState.currentGuests[index]),
                ),
              ),
              Expanded( // Ingredient Inventory 
                flex: 3, // give more space to the ingredients
                child: Wrap(
                  children: gameState.availableIngredients.map((ingredient) => IngredientWidget(ingredient)).toList(),
                ),
              ),
              PreparationArea(),
              WasteMeter(wasteLevel: gameState.wasteAmount)
            ],
          );
        },
      ),
    );
  }
}