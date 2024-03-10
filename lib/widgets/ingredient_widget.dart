import 'package:flutter/material.dart';
import '../models/ingredient.dart';

class IngredientWidget extends StatelessWidget {
  final Ingredient ingredient;

  IngredientWidget(this.ingredient);

  @override
  Widget build(BuildContext context) {
    // Wrap the container in a Draggable widget
    return Draggable<Ingredient>(
      // Data to be transferred
      data: ingredient,
      // The widget to display as the item is being dragged
      feedback: Material(
        color: Colors.transparent, // Make the Material widget's background transparent
        child: Image.asset(
          ingredient.imageUrl,
          width: 50, // Match the width in the Container below
          height: 50, // Match the height in the Container below
        ),
        elevation: 0, // Remove any shadow
      ),
      // The widget that remains in place where the Draggable widget was originally
      childWhenDragging: Container(), // You can decide to show nothing or a placeholder
      // The widget displayed when not dragging
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.0), // Adds a little space between each ingredient
        padding: EdgeInsets.all(8.0), // Padding inside the box
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7), // Semi-transparent white background
          borderRadius: BorderRadius.circular(8), // Rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Use the minimum space
          children: <Widget>[
            Image.asset(
              ingredient.imageUrl,
              width: 50, // Set a fixed width for the image
              height: 50, // Set a fixed height for the image
            ),
            Text(
              ingredient.name,
              style: TextStyle(fontSize: 12), // Smaller font size
              overflow: TextOverflow.ellipsis, // Prevent long names from breaking the layout
            ),
          ],
        ),
      ),
    );
  }
}
