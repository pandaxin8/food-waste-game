import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_waste_game/screens/sign_in_screen.dart';
import 'package:food_waste_game/screens/tutorial_screen.dart';
import 'package:food_waste_game/services/firebase_options.dart';
import 'package:food_waste_game/widgets/intro_cut_scene.dart';
import 'package:provider/provider.dart';
import '../state/game_state.dart';
import '../screens/main_menu_screen.dart';
import '../screens/game_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_waste_game/services/background_music_service.dart';


// Import additional screen files as you create them


class AppRoutes {
  static const mainMenu = '/';
  static const gameScreen = '/game';
  static const signIn = '/signIn'; 
  static const introCutScene = '/introCutScene'; 
  static const tutorial = '/tutorial';
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter initialization
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize music
  final musicService = BackgroundMusicService();
  //await musicService.startBackgroundMusic(); 

  runApp(
    MultiProvider( // Wrap your app with MultiProvider
      providers: [
        ChangeNotifierProvider(create: (_) => GameState()),
        Provider<BackgroundMusicService>.value(value: musicService),
      ],
      child: MyApp(musicService: musicService),
    ),
  );
}


class MyApp extends StatefulWidget {
  final BackgroundMusicService musicService;

  MyApp({Key? key, required this.musicService}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();

}

class _MyAppState extends State<MyApp> {
  //final BackgroundMusicService musicService = BackgroundMusicService();
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (mounted) {
    //     Provider.of<BackgroundMusicService>(context, listen: false).startBackgroundMusic();
    //   }
    // });
  }

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
              Provider<BackgroundMusicService>.value(value: widget.musicService),
            ],
            child: MaterialApp(
              title: 'Green Paw Chefs',
              theme: ThemeData(
                primarySwatch: Colors.green, // Use a green swatch
                primaryColor: Colors.green.shade400,
                primaryColorDark: Colors.green.shade800,
                // If you need a specific green, define it like this:
                // primaryColor: Color(0xFF4CAF50), // Replace with your desired green color code
                // Define other theme properties as needed
              ),
              initialRoute: AppRoutes.mainMenu,
              routes: {
                AppRoutes.mainMenu: (context) => MainMenuScreen(),
                // AppRoutes.gameScreen: (context) => GameScreen(),
                AppRoutes.signIn: (context) => SignInScreen(), 
                // Ensure you have a level to pass, this might require fetching from GameState or similar
                AppRoutes.introCutScene: (context) => IntroCutscene(),
                AppRoutes.tutorial: (context) => InteractiveTutorialScreen(),
                AppRoutes.gameScreen: (context) {
                  // Ensure you have a level to pass, this might require fetching from GameState or similar
                  final gameState = Provider.of<GameState>(context, listen: false);
                  if (gameState.currentLevel != null) {
                    return GameScreen(level: gameState.currentLevel!);
                  } else {
                    // Handle the case where currentLevel is null. Maybe navigate to an error page or a loading screen?
                    // For simplicity, returning a placeholder here:
                    return Scaffold(body: Center(child: Text("Level data is not available")));
                  }
                },
                // Add other routes here
              },
              onGenerateRoute: (settings) {
                if (settings.name == AppRoutes.signIn) {
                  // Provider.of<BackgroundMusicService>(context, listen: false).startBackgroundMusic();
                  // Optionally stop music when on the sign-in screen:
                  //Provider.of<BackgroundMusicService>(context, listen: false).pauseBackgroundMusic();
                  //print('try play music');
                  //Provider.of<BackgroundMusicService>(context, listen: false).startBackgroundMusic();
                } 
                // ...
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
  

