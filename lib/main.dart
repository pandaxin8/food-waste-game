import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_waste_game/services/firebase_options.dart';
import 'package:provider/provider.dart';
import '../state/game_state.dart';
import '../screens/main_menu_screen.dart';
import '../screens/game_screen.dart';

// Import additional screen files as you create them


class AppRoutes {
  static const mainMenu = '/';
  static const gameScreen = '/game';
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter initialization
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider( // Wrap your app with MultiProvider
      providers: [
        ChangeNotifierProvider(create: (_) => GameState()),
      ],
      child: MyApp(),
    ),
  );
}

// void main() => runApp(
//   MultiProvider( // Wrap your app with MultiProvider
//     providers: [
//       ChangeNotifierProvider(create: (_) => GameState()),
//     ],
//     child: MyApp(),
//   ),
// );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Virtual Restaurant',
      initialRoute: AppRoutes.mainMenu, 
      routes: {
        AppRoutes.mainMenu: (context) => MainMenuScreen(),
        AppRoutes.gameScreen: (context) => GameScreen(),
      },
    );
  }
}