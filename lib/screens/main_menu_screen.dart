import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_waste_game/main.dart';
import 'package:provider/provider.dart';
import '../state/game_state.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'quit.dart'; 

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
                onPressed: () async {
                  // Handle New Game action
                  //Provider.of<GameState>(context, listen: false).startNewGame(context); 
                  await Provider.of<GameState>(context, listen: false).startNewGame(context); // Await for startNewGame to complete 
                  Navigator.pushReplacementNamed(context, AppRoutes.gameScreen);
                  Provider.of<GameState>(context, listen: false).loadCurrentPlayerData();
                },
                child: Text('New Game'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(104, 175, 226, 100),
                  foregroundColor: Colors.white,
                  ),
              ),
              SizedBox(height: 20), // Spacing between buttons
              ElevatedButton(
                 onPressed: () {
                  if (kIsWeb) {
                    // Show dialog for web
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Quit Game'),
                          content: Text('To quit the game, please close the browser tab.'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    // Quit the app on mobile
                    quitApp();
                  }
                },
                child: Text('Quit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(104, 175, 226, 100),
                  foregroundColor: Colors.white,
                  ),
              ),
              // ... (Other buttons: Load Saved Game, High Scores, Educational Content)
            ],
          ),
        ),
      ),
    );
  }
}