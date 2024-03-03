import 'package:flutter/material.dart';
import '../models/ingredient.dart';

class IngredientWidget extends StatelessWidget {
  final Ingredient ingredient;
  IngredientWidget(this.ingredient);

  @override
  Widget build(BuildContext context) {
    return Draggable(
      data: ingredient,
      child: Container(
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Color(0xFF8B4513), // Woody brown color
          borderRadius: BorderRadius.circular(8.0), // Rounded corners for wooden frames
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(ingredient.imageUrl, height: 60),
            SizedBox(height: 5),
            Text(
              ingredient.name,
              style: TextStyle(color: Colors.white), // Set text color to white
            ),
          ],
        ),
      ),
      feedback: Opacity(
        opacity: 0.6,
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFF8B4513), // Woody brown color
            borderRadius: BorderRadius.circular(8.0), // Rounded corners for wooden frames
          ),
          child: Image.asset(ingredient.imageUrl, height: 80),
        ),
      ),
    );
  }
}
