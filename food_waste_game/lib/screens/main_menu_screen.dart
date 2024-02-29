import 'package:flutter/material.dart';
import 'package:food_waste_game/main.dart';
import 'package:food_waste_game/screens/game_screen.dart';
import 'package:provider/provider.dart';
import '../state/game_state.dart';


class MainMenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Virtual Restaurant'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // ... Logic to start the game ... 
                Provider.of<GameState>(context, listen: false).startNewGame(); 
                Navigator.pushReplacementNamed(context, AppRoutes.gameScreen);
                // Navigator.push(context, MaterialPageRoute(builder: (context) => GameScreen()));
              },
              child: Text('New Game'),
            ),
            ElevatedButton(
              onPressed: () {
                // ... Logic to Quit (check platform for how to handle exiting) ... 
              },
              child: Text('Quit'),
            ),
            // ... (Other buttons: Load Saved Game, High Scores, Educational Content)
          ],
        ),
      ),
    );
  }
}