import 'package:flutter/material.dart';
import 'package:food_waste_game/models/objective.dart';
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
            // Check if there's a current level and it has objectives
            if (gameState.currentLevel != null && gameState.currentLevel!.objectives.isNotEmpty) {
              // Now we know there are objectives, so we can safely show them
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
            } else {
              // Handle the case where there are no objectives or no current level
              print('No objectives exist or no current level is set.');
              // Optionally, show a message to the user
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('No objectives to show.'),
                ),
              );
            }
          },
          child: IconButton(
            icon: Icon(Icons.list_alt_outlined), // You can choose a different icon here
            onPressed: () {
              if (gameState.currentLevel != null && gameState.currentLevel!.objectives.isNotEmpty) {
                showDialog(
                  context: context,
                  builder: (context) => ObjectivesDialog(objectives: gameState.currentLevel?.objectives),
                );
              } else {
                // Optionally handle the tap when there are no objectives
                print('No objectives to show in dialog.');
              }
            },
          ),
        );
      },
    );
  }
}


class ObjectivesDialog extends StatelessWidget {
  final List<Objective>? objectives;

  const ObjectivesDialog({Key? key, this.objectives}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Current Level Objectives'),
      content: objectives == null || objectives!.isEmpty
          ? Text('No objectives for this level.')
          : ListView.builder(
              shrinkWrap: true, // Prevent the dialog from growing too large
              itemCount: objectives!.length,
              itemBuilder: (context, index) {
                final objective = objectives![index];
                return Row(
                  children: [
                    Icon(objective.isCompleted ? Icons.check_circle_outline_outlined : Icons.circle_outlined),
                    SizedBox(width: 30),
                    Flexible(
                      child: Text(objective.description),
                      ),
                    
                  ],
                );
              },
            ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Close'),
        ),
      ],
    );
  }
}