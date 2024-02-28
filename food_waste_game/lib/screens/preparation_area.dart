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

  @override
  Widget build(BuildContext context) {
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
                  avatar: Image.network(ingredient.imageUrl, height: 25),
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
                  // 1. Create 'Dish' object from _selectedIngredients
                  // 2. Call a method like gameState.submitDish(dish)
                  // 3. Potentially clear _selectedIngredients
                },
                child: Text('Cook'), 
              );
            },
          ),
        ],
      ),
    );
  }
}