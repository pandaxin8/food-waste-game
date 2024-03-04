import 'package:flutter/material.dart';
import 'package:food_waste_game/state/game_state.dart';
import 'package:provider/provider.dart';


class ObjectiveTracker extends StatefulWidget {
  const ObjectiveTracker({Key? key}) : super(key: key);

  @override
  _ObjectiveTrackerState createState() => _ObjectiveTrackerState();
}

class _ObjectiveTrackerState extends State<ObjectiveTracker> {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(
            builder: (context, gameState, child) {
              return GestureDetector(
                onTap: () {
                  // Handle click on the objective tracker
                  // ... your code to show objectives ...
        
                  print(gameState.currentLevel);
        
                  if (gameState.currentLevel == null) {
                    // handle this case
                  }
        
                  if (gameState.currentLevel?.objectives == null || gameState.currentLevel!.objectives.isEmpty) {
                    print('no objectives exist');
                    return; // Handle the case where no objectives exist
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Current Level Objectives:"),
                          ...gameState.currentLevel!.objectives.map((objective) => Text(objective.description)).toList(),
                        ],
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                 decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8), // Semi-transparent white background
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(2, 2))
                  ], 
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: gameState.currentLevel?.objectives.map((objective) {
                      return Row(
                        children: [
                          Icon(objective.isCompleted ? Icons.check : Icons.circle_outlined),
                          SizedBox(width: 10),
                          Text(objective.description),
                        ],
                      );
                    }).toList() ?? [], // Handle the case where no level is loaded
                  ),
                ),
              );
            },
          );
  }
}