import 'package:flutter/material.dart';
import 'package:food_waste_game/models/dish.dart';
import 'package:food_waste_game/models/ingredient.dart';
import 'package:food_waste_game/widgets/dish_widget.dart';

class DishPreparationTutorial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Ingredient> tutorialIngredients = [
      // Assume these are the ingredients required for a tutorial dish
    ];

    final Dish tutorialDish = Dish(
      name: 'Garden Salad',
      ingredients: tutorialIngredients,
      prepTime: 10,
      satisfiesTags: ['vegan', 'low-calorie'],
      unlockLevel: 1,
      imagePath: 'assets/images/dishes/garden-salad.png',
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dish Preparation',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(
            'Combine the selected ingredients to create a dish. For example, let\'s make a Garden Salad!',
          ),
          SizedBox(height: 20),
          Center(
            child: DishWidget(dish: tutorialDish),
          )
          // Simulate the preparation process here
        ],
      ),
    );
  }
}
