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
      child: Row(
        children: [
          Expanded(
            flex: wasteLevel, // Flexible, so the bar fills as waste increases
            child: Container(
              color: Colors.red, // Color for indicating waste
            ),
          ),
          Expanded(
            flex: 100 - wasteLevel, // Remaining space represents 'good'
            child: Container(
              color: Colors.green,
            ),
          )
        ],
      ),
    );
  }
}