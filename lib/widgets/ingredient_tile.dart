import 'package:flutter/material.dart';
import 'package:food_waste_game/models/ingredient.dart';

class IngredientTile extends StatelessWidget {
  final Ingredient ingredient;
  final Function onDragged;

  const IngredientTile({
    Key? key,
    required this.ingredient,
    required this.onDragged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Draggable<Ingredient>(
      data: ingredient,
      child: Container(
        width: 50, // Set the width for your ingredient icon
        height: 50, // Set the height for your ingredient icon
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Image.asset(ingredient.imageUrl, fit: BoxFit.contain),
      ),
      feedback: Container(
        width: 50,
        height: 50,
        child: Image.asset(ingredient.imageUrl, fit: BoxFit.contain),
      ),
      onDragEnd: (details) {
        if (details.wasAccepted) {
          onDragged(ingredient);
        }
      },
      childWhenDragging: Container(),
    );
  }


}
