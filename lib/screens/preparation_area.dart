import 'package:flutter/material.dart';
import 'package:food_waste_game/widgets/ingredient_tile.dart';
import 'package:provider/provider.dart';
import '../models/ingredient.dart';
import '../state/game_state.dart';


class PreparationArea extends StatefulWidget {
  final List<Ingredient> selectedIngredients;
  final int maxIngredients;

  PreparationArea({
    required this.selectedIngredients,
    this.maxIngredients = 4, // Optionally limit the number of ingredients
  });

  @override
  _PreparationAreaState createState() => _PreparationAreaState();
}

class _PreparationAreaState extends State<PreparationArea> {

  void _removeIngredient(Ingredient ingredient) {
    setState(() {
      widget.selectedIngredients.remove(ingredient);
    });
  }


  @override
  Widget build(BuildContext context) {
    // The background image for the preparation area
    final String backgroundImage = 'assets/images/backgrounds/preparation-area.png';
    // The target area image, e.g., an outline of a bowl or a cutting board
    // final String targetAreaImage = 'assets/images/target-area.png';

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(backgroundImage),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Image.asset('assets/images/environment/pot.png', height: 100),
          SizedBox(height: 10),
          Flexible(
            child: DragTarget<Ingredient>(
              onAccept: _handleAcceptIngredient,
              builder: (context, candidateData, rejectedData) {
                return ListView.builder(
                    scrollDirection: Axis.horizontal, // Set this to horizontal
                    itemCount: widget.selectedIngredients.length,
                    itemBuilder: (context, index) {
                      final ingredient = widget.selectedIngredients[index];
                      return Draggable<Ingredient>(
                        data: ingredient,
                        feedback: Material(
                          child: _buildIngredientTile(ingredient), // Material is needed for the dragged item
                          elevation: 4.0,
                        ),
                        childWhenDragging: Container(
                          width: 60, // Match the size of the ingredient tile
                          height: 60,
                          decoration: BoxDecoration(
                            // Maybe a border to show an empty space
                          ),
                        ),
                        onDragStarted: () {
                          // Handle drag start if necessary
                        },
                        onDraggableCanceled: (velocity, offset) {
                          _removeIngredient(ingredient); // Remove the ingredient if dragged back
                        },
                        onDragEnd: (details) {
                          // This is called when the drag does not end on a DragTarget.
                          if (!details.wasAccepted) {
                            setState(() {
                              // Assuming you have a method to increase the waste count.
                              context.read<GameState>().incrementWaste(ingredient);
                              // Then remove the ingredient from the selection.
                              widget.selectedIngredients.removeAt(index);
                            });
                          }
                        },
                        child: _buildIngredientTile(ingredient), // Normal state
                      );
                    },
                  );
              },
            ),
          ),
          Consumer<GameState>(
                builder: (context, gameState, child) {
                  return ElevatedButton(
                    onPressed: () {
                      // 1. Check Objectives
                      gameState.checkObjective2Completion(widget.selectedIngredients);

                      // 2. Submit Dish
                      gameState.submitDish(widget.selectedIngredients, context); 

                      // 3. After submitting the dish, check for level completion
                      if (gameState.checkIfObjectivesCompleted()) {
                        gameState.onLevelComplete(context);
                      }

                      // 4. Clear Ingredients (if desired)
                      setState(() {
                        widget.selectedIngredients.clear(); 
                      });
                    },
                    child: Text('Cook'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF8B4513),
                      foregroundColor: Colors.white,
                    ), 
                  );
                },
              ),
        ],
      ),
);
  }


    Widget _buildIngredientTile(Ingredient ingredient, {bool isDragging = false}) {
  return Container(
    width: 60, // Set the width to fit the image
    height: 60, // Set the height to fit the image
    decoration: BoxDecoration(
      color: ingredient.isSelected ? Colors.green.withOpacity(0.5) : Colors.transparent,
      border: Border.all(
        color: ingredient.isSelected ? Colors.green : Colors.transparent, // Border color when selected
        width: 2, // Border width
      ),
      borderRadius: BorderRadius.circular(10), // Adjust the radius to fit your design
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0), // Padding inside the container
      child: Image.asset(
        ingredient.imageUrl,
        fit: BoxFit.contain, // Contain the image within the available space
      ),
    ),
  );
}

void _handleAcceptIngredient(Ingredient ingredient) {
    setState(() {
      if (!widget.selectedIngredients.contains(ingredient)) {
        widget.selectedIngredients.add(ingredient);
        // Mark the ingredient as selected
        ingredient.isSelected = true;
      }
    });
  }

  Widget _buildBin() {
    return Positioned(
      top: 0, // Adjust position based on where the bin is located
      right: 0,
      child: DragTarget<Ingredient>(
        // Existing bin DragTarget code
        onWillAccept: (ingredient) => true, // Accept all ingredients
    onAccept: (ingredient) {
      _removeIngredient(ingredient);
    },
    builder: (context, candidateData, rejectedData) {
      return Icon(
        Icons.delete, // The bin icon
        color: const Color.fromARGB(255, 133, 67, 63),
        size: 20, // Size of the bin icon
        
      );
    }
      )
    );
  }


}
