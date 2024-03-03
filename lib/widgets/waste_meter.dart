import 'package:flutter/material.dart';

class WasteMeter extends StatelessWidget {
  final int wasteLevel;
  WasteMeter({required this.wasteLevel}); 

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      child: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            color: const Color.fromARGB(255, 123, 170, 125), // Default color for the whole meter
          ),
          Container(
            height: double.infinity,
            width: MediaQuery.of(context).size.width * (wasteLevel / 100), // Adjusted width based on waste level
            color: Colors.red, // Color for indicating waste
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(Icons.eco, color: Color.fromARGB(216, 20, 236, 189)), // Leaf icon for low waste
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(Icons.delete, color: const Color.fromARGB(255, 235, 112, 103)), // Trash bin icon for high waste
              ),
            ],
          ),
        ],
      ),
    );
  }
}
