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
        child: Column(
          children: [
            Image.network(ingredient.imageUrl, height: 60),
            SizedBox(height: 5),
            Text(ingredient.name),
          ],
        ),
      ),
      feedback: Opacity( // Visual feedback when dragged
        opacity: 0.6,
        child: Image.network(ingredient.imageUrl, height: 80),
      ),
    );
  }
} 