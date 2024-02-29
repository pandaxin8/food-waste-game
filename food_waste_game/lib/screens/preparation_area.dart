import 'package:flutter/material.dart';
import 'package:food_waste_game/models/ingredient.dart';
import 'package:provider/provider.dart';
import '../models/dish.dart'; 
import '../state/game_state.dart';


class PreparationArea extends StatefulWidget {
  @override
  _PreparationAreaState createState() => _PreparationAreaState();
}

class _PreparationAreaState extends State<PreparationArea> {
  List<Ingredient> _selectedIngredients = [];

  void _handleIngredientDrop(Ingredient ingredient) {
    setState(() {
      _selectedIngredients.add(ingredient);
    });
  }

  // Helper function to calculate the list of tags
  List<String> calculateSatisfiesTags(List<Ingredient> ingredients) {
    return ingredients.expand((ingredient) => ingredient.dietaryTags).toSet().toList();
  }

  @override
  Widget build(BuildContext context) {
    return DragTarget<Ingredient>(
      onAccept: _handleIngredientDrop,
      builder: (context, candidateData, rejectedData) {
        return Container(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Text('Preparation Area'),
          SizedBox(height: 15),
          Wrap( // Display selected ingredients
            children: _selectedIngredients.map((ingredient) => 
              Container(
                margin: const EdgeInsets.all(4.0),
                child: Chip(
                  //avatar: Image.network(ingredient.imageUrl, height: 25),
                  avatar: Image.asset(ingredient.imageUrl, height: 25),
                  label: Text(ingredient.name),
                  onDeleted: () {
                    setState(() {
                      _selectedIngredients.remove(ingredient);
                    });
                  },
                ),
              ),
            ).toList(),
          ),
          SizedBox(height: 20),
          Consumer<GameState>( // Access GameState to submit dishes
            builder: (context, gameState, child) {
              return ElevatedButton(
                onPressed: () {
                  // 1. Create the Dish object
                  Dish dish = Dish(
                    name: 'Custom Dish',
                    ingredients: _selectedIngredients,
                    prepTime: 5, 
                    satisfiesTags: calculateSatisfiesTags(_selectedIngredients), // Calculate the tags
                  );

                  // 2. Submit the dish to your game state
                  gameState.submitDish(dish, context); 

                  // 3. Clear the list of selected ingredients 
                  setState(() {
                    _selectedIngredients.clear(); 
                  });
                },
                child: Text('Cook'), 
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