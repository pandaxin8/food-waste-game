import 'package:flutter/material.dart';
import 'package:food_waste_game/main.dart';
import 'package:food_waste_game/screens/game_screen.dart';
import 'package:provider/provider.dart';
import '../state/game_state.dart';

class MainMenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/backgrounds/main-menu.png'),
            fit: BoxFit.cover, // This ensures the image covers the whole container
          ),
        ),
        child: Center(
          // Your main menu content here
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Handle New Game action
                  Provider.of<GameState>(context, listen: false).startNewGame(); 
                  Navigator.pushReplacementNamed(context, AppRoutes.gameScreen);
                  Provider.of<GameState>(context, listen: false).loadCurrentPlayerData();
                },
                child: Text('New Game'),
              ),
              SizedBox(height: 20), // Spacing between buttons
              ElevatedButton(
                onPressed: () {
                  // Handle Quit action
                },
                child: Text('Quit'),
              ),
              // ... (Other buttons: Load Saved Game, High Scores, Educational Content)
            ],
          ),
        ),
      ),
    );
  }
}