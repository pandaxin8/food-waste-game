import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/game_state.dart';
import '../screens/main_menu_screen.dart';
import '../screens/game_screen.dart';
// Import additional screen files as you create them

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => GameState(), // Instantiate your GameState
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key); // Constructor marked 'const'
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Virtual Restaurant',
      theme: ThemeData(
        primarySwatch: Colors.green, // Adjust your theme here
      ),
      initialRoute: '/', // Route to the main menu
      routes: {
        '/': (context) => MainMenuScreen(),
        '/game': (context) => GameScreen(),
        // Add routes for other screens as needed 
      },
    );
  }
}