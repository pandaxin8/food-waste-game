import 'package:flutter/material.dart';
import 'package:food_waste_game/models/dish.dart';


class DishWidget extends StatelessWidget {
  final Dish dish;

  // Using named parameters for better clarity
  DishWidget({required this.dish});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Image.asset(
            dish.imagePath, // Use the image path from the Dish object
            height: 120,
          ),
          Text(
            dish.name,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          // You can add more details such as prep time or dietary tags here
        ],
      ),
    );
  }
}

