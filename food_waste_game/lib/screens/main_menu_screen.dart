import 'package:flutter/material.dart';
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
                Provider.of<GameState>(context, listen: false).startNewGame(); 
                Navigator.push(context, MaterialPageRoute(builder: (context) => GameScreen()));
              },
              child: Text('New Game'),
            ),
            // ... (Other buttons: Load Saved Game, High Scores, Educational Content)
          ],
        ),
      ),
    );
  }
}