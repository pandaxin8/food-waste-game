import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_waste_game/screens/sign_in_screen.dart';
import 'package:food_waste_game/services/firebase_options.dart';
import 'package:provider/provider.dart';
import '../state/game_state.dart';
import '../screens/main_menu_screen.dart';
import '../screens/game_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';


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




class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // While checking user authentication state, show loading indicator
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }
        // If user is signed in, use MultiProvider for state management
        if (snapshot.hasData) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => GameState()),
            ],
            child: MaterialApp(
              title: 'Virtual Restaurant',
              initialRoute: AppRoutes.mainMenu,
              routes: {
                AppRoutes.mainMenu: (context) => MainMenuScreen(),
                AppRoutes.gameScreen: (context) => GameScreen(),
                // Add other routes here
              },
            ),
          );
        }
        // If user is not signed in, direct to SignInScreen
        else {
          return MaterialApp(
            home: SignInScreen(), // Implement SignInScreen
          );
        }
      },
    );
  }
}
