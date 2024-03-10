import 'package:flutter/material.dart';
import 'package:food_waste_game/models/ingredient.dart';
import 'package:food_waste_game/widgets/ingredient_widget.dart';

class IngredientSelectionTutorial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Ingredient> tutorialIngredients = [
      Ingredient(
        name: 'Tomato',
        imageUrl: 'assets/images/ingredients/tomato.png',
        dietaryTags: ['vegan', 'vegetarian'],
        calories: 18,
        isSelected: false,
        freshness: 80,
        isLocal: true,
      ),
      // Add more ingredients as needed for the tutorial
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            Text(
              'Selecting Ingredients',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

           Text(
              'Pick ingredients that are expiring soon to reduce waste. Also, consider the dietary tags and calories for healthy meal options.',
            ),
          
          SizedBox(height: 20),
          Center(
            child: Wrap(
              children: tutorialIngredients.map((ingredient) => IngredientWidget(ingredient)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
