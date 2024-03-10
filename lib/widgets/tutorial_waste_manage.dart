import 'package:flutter/material.dart';
import 'package:food_waste_game/widgets/waste_meter.dart';


class WasteManagementTutorial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Waste Management',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(
            'Keep an eye on the Waste Meter! Manage your ingredients to prevent waste. Use ingredients wisely and avoid unnecessary preparation.',
          ),
          SizedBox(height: 20),
          // WasteMeter widget will show the current level of waste
          Center(
            child: WasteMeter(wasteLevel: 1), // Assume this is the initial waste level
          ),
        ],
      ),
    );
  }
}
