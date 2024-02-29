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
      body: Consumer<GameState>(
        builder: (context, gameState, child) {
          return Column(
            children: [
              Expanded(
                flex: 2,
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.white, Colors.transparent, Colors.transparent, Colors.white],
                      stops: [0.0, 0.1, 0.9, 1.0],
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.dstOut,
                  child: Scrollbar(
                   // isAlwaysShown: true,
                    child: ListView.builder(
                      itemCount: gameState.currentGuests.length,
                      itemBuilder: (context, index) => GuestProfileWidget(guest: gameState.currentGuests[index]),
                    ),
                  ),
                ),
              ),
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

// class GameScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Game Screen'), 
//         actions: [
//           Consumer<GameState>(
//             builder: (context, gameState, child) {
//               return IconButton(
//                 icon: Icon(gameState.isPaused ? Icons.play_arrow : Icons.pause),
//                 onPressed: () {
//                   // toggle game pause state
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
//              // ... Return to main menu ... 
//              Navigator.pushReplacementNamed(context, AppRoutes.mainMenu);
//             },
//           )
//         ],
//         // title: Consumer<GameState>( // Update app bar elements dynamically
//         //   builder: (context, gameState, child) {
//         //     return Text('Score: ${gameState.score} - Level: ${gameState.currentLevel}'); 
//         //   },
//         // ),
//       ),
//       body: Consumer<GameState>(
//         builder: (context, gameState, child) {
//           return Column(
//             children: [
//               Expanded( // Guest Profiles
//                 flex: 2, // give more space to the guests
//                 child: ListView.builder(
//                   itemCount: gameState.currentGuests.length,
//                   itemBuilder: (context, index) => GuestProfileWidget(guest: gameState.currentGuests[index]),
//                 ),
//               ),
//               Expanded( // Ingredient Inventory 
//                 flex: 3, // give more space to the ingredients
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
// }