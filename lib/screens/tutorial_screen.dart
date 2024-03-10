import 'package:flutter/material.dart';
import 'package:food_waste_game/main.dart';
import 'package:food_waste_game/state/game_state.dart';
import 'package:food_waste_game/widgets/tutorial_appbar_icons.dart';
import 'package:food_waste_game/widgets/tutorial_dish_prep.dart';
import 'package:food_waste_game/widgets/tutorial_ingredient_selection.dart';
import 'package:food_waste_game/widgets/tutorial_waste_manage.dart';
import 'package:provider/provider.dart';



class InteractiveTutorialScreen extends StatefulWidget {
  @override
  _InteractiveTutorialScreenState createState() => _InteractiveTutorialScreenState();
}

class _InteractiveTutorialScreenState extends State<InteractiveTutorialScreen> {
  int _tutorialStep = 0;

  void _nextTutorialStep() {
    setState(() {
      _tutorialStep++;
    });
  }

  void _previousTutorialStep() {
    if (_tutorialStep > 0) {
      setState(() {
        _tutorialStep--;
      });
    }
  }

  @override
Widget build(BuildContext context) {
  List<Widget> tutorialSteps = [
    _buildIntroduction(context),
    _buildIngredientSelection(context),
    _buildDishPreparation(context),
    _buildWasteManagement(context),
    _buildAppBarIcons(context),
    _buildClosingRemarks(context),
  ];

  return Scaffold(
    appBar: AppBar(
      title: Text('Tutorial'),
    ),
    body: Stack(
      fit: StackFit.expand, // Ensure the stack fills the screen
      children: [
        Opacity(
          opacity: 0.3, // Adjust the opacity for the faded effect
          child: Image.asset(
            'assets/images/backgrounds/game-background.png', // Replace with your background image asset
            fit: BoxFit.cover, // Cover the screen with the image
          ),
        ),
        SingleChildScrollView(
      child: Column(
        children: [
          tutorialSteps[_tutorialStep],
          // if (_tutorialStep < tutorialSteps.length - 1) tutorialSteps[_tutorialStep],
          // if (_tutorialStep == tutorialSteps.length - 1)
            // ElevatedButton(
            //     onPressed: () async {
            //       final gameState = Provider.of<GameState>(context, listen: false);
            //       await gameState.loadLevel(1); // Make sure this is the right method to load the initial level

            //       if (gameState.currentLevel != null) {
            //         Navigator.pushReplacementNamed(context, AppRoutes.gameScreen);
            //       } else {
            //         ScaffoldMessenger.of(context).showSnackBar(
            //           SnackBar(content: Text('Unable to load the level data. Please try again.'))
            //         );
            //       }
            //     },
            //     child: Text('Start the Game!'),
            // ),
        ],
      ),
        ),
      ],
    ),
    bottomNavigationBar: _tutorialStep < tutorialSteps.length  ? BottomAppBar(
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            TextButton(
              onPressed: () async {
                // Skip logic
                final gameState = Provider.of<GameState>(context, listen: false);
                  await gameState.startNewGame(context);

                  if (gameState.currentLevel != null) {
                    Navigator.pushReplacementNamed(context, AppRoutes.gameScreen);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Unable to load the level data. Please try again.'))
                    );
                  }
              },
              child: Text('Skip Tutorial', style: TextStyle(color: Theme.of(context).canvasColor)),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Theme.of(context).canvasColor),
                  onPressed: _previousTutorialStep,
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward, color: Theme.of(context).canvasColor),
                  onPressed: _nextTutorialStep,
                ),
              ],
            ),
          ],
        ),
      ),
    ) : null,
    );
  }
  Widget _buildIntroduction(BuildContext context) {
  // Introduction text and narrative
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Welcome to Green Paw Chefs!",
          style: Theme.of(context).textTheme.headline5?.copyWith(color: Theme.of(context).primaryColorDark),
        ),
        SizedBox(height: 8),
        RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyText1,
            children: [
              TextSpan(text: "As the "),
              TextSpan(text: "new head chef ", style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: "in this sustainable restaurant, your mission is to "),
              TextSpan(text: "create delicious dishes ", style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: "for your guests while minimizing food waste. "),
            ],
          ),
        ),
        SizedBox(height: 16),
        Text(
          "Let's start by learning how to select ingredients.",
          style: Theme.of(context).textTheme.subtitle1,
        ),
        // Add an illustrative icon or image
        Center(
          child: Icon(
            Icons.restaurant_menu,
            size: 48,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    ),
  );
}


  Widget _buildIngredientSelection(BuildContext context) {
    // Show ingredient widgets and explain selection based on freshness
    return IngredientSelectionTutorial();
  }

  Widget _buildDishPreparation(BuildContext context) {
    // Show how to combine ingredients into dishes
    return DishPreparationTutorial();
  }

  Widget _buildWasteManagement(BuildContext context) {
    // Explain waste meter and how to avoid waste
    return WasteManagementTutorial();
  }

  Widget _buildAppBarIcons(BuildContext context) {
    // Explain Appbar icons and their functionlaities
    return TutorialAppBarIcons();
  }

 Widget _buildClosingRemarks(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start of the axis
      children: [
        Text(
          "Great job! Remember, each choice you make impacts the environment. Try different combinations, keep learning, and most importantly, have fun reducing food waste!",
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 20), // Provide some spacing before the button
        Center( // Center the button horizontally
          child: ElevatedButton(
            onPressed: () async {
              final gameState = Provider.of<GameState>(context, listen: false);
              await gameState.startNewGame(context);

              if (gameState.currentLevel != null) {
                Navigator.pushReplacementNamed(context, AppRoutes.gameScreen);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Unable to load the level data. Please try again.'))
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF8D6E63), // Wood color button
              foregroundColor: Colors.white, // Text color
              padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0), // Button internal padding
            ),
            child: Text('Start the Game!'),
          ),
        ),
      ],
    ),
  );
}




}


