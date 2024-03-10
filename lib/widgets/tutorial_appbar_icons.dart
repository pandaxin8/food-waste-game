import 'package:flutter/material.dart';

class TutorialAppBarIcons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Understanding the Game Icons',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Guest Profiles'),
            subtitle: Text('Shows profiles of guests currently in the restaurant.'),
          ),
          ListTile(
            leading: Icon(Icons.list_alt_outlined),
            title: Text('Level Objectives'),
            subtitle: Text('Displays the objectives for the current level.'),
          ),
          ListTile(
            leading: Icon(Icons.star),
            title: Text('Simulate Level Completion'),
            subtitle: Text('Simulates completing the current level for demonstration purposes.'),
          ),
          ListTile(
            leading: Icon(Icons.menu_book),
            title: Text('Available Dishes'),
            subtitle: Text('Shows the dishes you can prepare in the current level.'),
          ),
          ListTile(
            leading: Icon(Icons.pause),
            title: Text('Pause/Resume Game'),
            subtitle: Text('Allows you to pause the game. Tap again to resume.'),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Main Menu'),
            subtitle: Text('Returns to the main menu. Be sure to save your progress!'),
          ),
        ],
      ),
    );
  }
}
