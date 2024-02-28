import 'package:flutter/material.dart';
import '../models/guest.dart';

class GuestProfileWidget extends StatelessWidget {
  final Guest guest;
  GuestProfileWidget({required this.guest});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Image.network(guest.preferenceIcon, height: 40), // Display the preference icon 
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(guest.name, style: TextStyle(fontWeight: FontWeight.bold)), 
                Wrap( // Wrap the dietary restrictions in a row
                  children: guest.dietaryRestrictions.map((restriction) => 
                    Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: Chip(label: Text(restriction)),
                    ),
                  ).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 