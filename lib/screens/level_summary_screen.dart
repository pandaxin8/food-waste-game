import 'package:flutter/material.dart';
import 'package:food_waste_game/state/game_state.dart';

class LevelSummaryScreen extends StatefulWidget {
  final GameState gameState;

  const LevelSummaryScreen({Key? key, required this.gameState}) : super(key: key);

  @override
  _LevelSummaryScreenState createState() => _LevelSummaryScreenState();
}

class _LevelSummaryScreenState extends State<LevelSummaryScreen> {
  @override
  Widget build(BuildContext context) {
    // Define color based on waste produced
    Color wasteColor = widget.gameState.wasteAmount == 0 ? Colors.green : Theme.of(context).errorColor;

    return Scaffold(
      appBar: AppBar(
        title: Text('Level Summary'),
        centerTitle: true, // Center the title if not already centered
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/backgrounds/level-summary-background.png'), // Your actual background image
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.7), BlendMode.dstATop), // Lighten the image for better text readability
          ),
        ),
        child: Center( // Center align the elements
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // This will center the column contents vertically
              crossAxisAlignment: CrossAxisAlignment.center, // This will center the column contents horizontally
              children: [
                Text(
                  'Score: ${widget.gameState.score}',
                  style: Theme.of(context).textTheme.headline4?.copyWith(
                    color: Color(0xFF8B4513),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Waste Produced: ${widget.gameState.wasteAmount}',
                  style: Theme.of(context).textTheme.headline6?.copyWith(color: wasteColor),
                ),
                Divider(height: 32.0, thickness: 2.0), // Add a divider for visual separation
                ...widget.gameState.madeDishes.map((dish) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0), // Add some space between the list items
                  child: Text(dish.name, textAlign: TextAlign.center), // Center align text
                )).toList(),
                Divider(height: 32.0, thickness: 2.0), // Another divider for separation
                Text(
                  widget.gameState.checkIfObjectivesCompleted() ? "All sustainability goals met!" : "Some sustainability goals were not met",
                  style: Theme.of(context).textTheme.subtitle1,
                  textAlign: TextAlign.center, // Center align text
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF8B4513),
                    padding: EdgeInsets.symmetric(horizontal: 48.0, vertical: 16.0), // Bigger button padding
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                  ),
                  onPressed: () async {
                    // Assuming you've ensured all necessary user interactions with notifications/dialogs are complete,
                    // you can now proceed to advance to the next level.
                    await widget.gameState.advanceToNextLevel(context);
                    
                    // If unlockLevelRewards is refactored to not immediately need context
                    // or if you're handling notifications in a way that doesn't block navigation
                    widget.gameState.unlockLevelRewards(context);
                  
                  },
                  child: Text('Continue', style: TextStyle(fontSize: 20, color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
