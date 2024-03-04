import 'package:flutter/material.dart';
import 'package:food_waste_game/models/ingredient.dart';
import 'package:provider/provider.dart';
import '../models/dish.dart'; 
import '../state/game_state.dart';



class PreparationArea extends StatefulWidget {
  final List<Ingredient> selectedIngredients;

  PreparationArea({required this.selectedIngredients});

  @override
  _PreparationAreaState createState() => _PreparationAreaState();
}

class _PreparationAreaState extends State<PreparationArea> {
  // Helper function to calculate the list of tags
  List<String> calculateSatisfiesTags(List<Ingredient> ingredients) {
    return ingredients.expand((ingredient) => ingredient.dietaryTags).toSet().toList();
  }

  // Function to determine which dishes can be made from selected ingredients
  List<Dish> getPossibleDishes() {
    // Placeholder, but you should implement filtering logic here
    // based on selected ingredients and availableDishes from GameState
    return Provider.of<GameState>(context, listen: false).availableDishes; 
  }

  @override
  Widget build(BuildContext context) {
    return DragTarget<Ingredient>(
      onAccept: (ingredient) {
        setState(() {
          widget.selectedIngredients.add(ingredient);
        });
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/backgrounds/preparation-area.png'), // Replace with your asset
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.9),
                spreadRadius: 3,
                blurRadius: 5,
                offset: Offset(0, 3), 
              ),
            ],
          ),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Image.asset('assets/images/environment/pot.png', height: 200),
              SizedBox(height: 15),
              Wrap(
                children: widget.selectedIngredients.map((ingredient) => 
                  Container(
                    margin: const EdgeInsets.all(4.0),
                    child: GestureDetector(
                      onTap: () {
                        final gameState = Provider.of<GameState>(context, listen: false); // Access GameState
                        setState(() {
                          ingredient.isSelected = !ingredient.isSelected;
                          // Update isSelected in your main availableIngredients in GameState
                          final matchingIngredient = gameState.availableIngredients.firstWhere((i) => i.name == ingredient.name);
                          matchingIngredient.isSelected = ingredient.isSelected; 
                        });
                        gameState.checkObjective1Completion(widget.selectedIngredients);
                      },
                      child: Chip( 
                        avatar: Image.asset(ingredient.imageUrl, height: 25),
                        label: Text(ingredient.name),
                        backgroundColor: ingredient.isSelected ? Colors.green : Colors.grey, 
                        onDeleted: () {
                          setState(() {
                            widget.selectedIngredients.remove(ingredient);
                            ingredient.isSelected = false; 
                          });
                        }, 
                      ),
                    ),
                  ),
                ).toList(),
              ),
              SizedBox(height: 20),
              Consumer<GameState>(
                builder: (context, gameState, child) {
                  return ElevatedButton(
                    onPressed: () {
                      // 1. Check Objectives
                      gameState.checkObjective2Completion(widget.selectedIngredients);

                      // 2. Submit Dish
                      gameState.submitDish(widget.selectedIngredients, context); 

                      // 3. Clear Ingredients (if desired)
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
      },
    );
  }
}