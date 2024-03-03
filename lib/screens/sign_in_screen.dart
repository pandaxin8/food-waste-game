import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_waste_game/state/game_state.dart';
import 'package:provider/provider.dart';




class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void checkCurrentUser() {
    var currentUser = FirebaseAuth.instance.currentUser;
    print("Current User: ${currentUser?.email}"); // Replace with UID or another identifier if you prefer
    if (currentUser == null) {
      print("No user is currently logged in.");
    } else {
      print("User is logged in: ${currentUser.email}");
    }
  }

  void _signInAnonymously() async {
    try {
      final userCredential = await _auth.signInAnonymously();
      if (userCredential.user != null) {
        // Load user-specific data here before navigating
        // Example: Loading player data
        await Provider.of<GameState>(context, listen: false).loadCurrentPlayerData();
        checkCurrentUser();

        Navigator.pop(context); // Navigates back to the main screen, data is ready
      }
    } catch (e) {
      // Handle errors, e.g., show an alert dialog
      print(e); // Consider replacing this with a more user-friendly error handling
    }
  }

  void _signInWithEmailAndPassword() async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (userCredential.user != null) {
        // Load user-specific data here before navigating
        // Example: Loading player data
        await Provider.of<GameState>(context, listen: false).loadCurrentPlayerData();
        checkCurrentUser();

        Navigator.pop(context); // Navigates back to the main screen, data is ready
      }
    } catch (e) {
      // Handle errors, e.g., show an alert dialog
      print(e); // Consider replacing this with a more user-friendly error handling
    }
  }


  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Sign In'),
      backgroundColor: Colors.transparent, // Add this line to make AppBar background transparent
      elevation: 0, // Add this line to remove shadow
    ),
    body: Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/backgrounds/sign-in.png"), // Your background image file
              fit: BoxFit.cover, // This will fill the whole Scaffold body
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Styled TextFields
                TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold), // Adjust label color
                  filled: true, // Add fill color
                  fillColor: Colors.white.withOpacity(0.7), // Semi-transparent white
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.brown), // Woody brown border
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: Colors.green[800]), // Adjust text color
              ),
                SizedBox(height: 16), // Spacing between textfields
                TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold), // Adjust label color
                  filled: true, // Add fill color
                  fillColor: Colors.white.withOpacity(0.7), // Semi-transparent white
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.brown), // Woody brown border
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: Colors.green[800]), // Adjust text color
              ),
                SizedBox(height: 20),

                SizedBox(height: 20),
              ElevatedButton(
                onPressed: _signInWithEmailAndPassword,
                child: Text('Sign In'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF8B4513), // Woody brown color
                  foregroundColor: Colors.white,
                ),
              ),
              SizedBox(height: 20), // Spacing between buttons
              ElevatedButton(
                onPressed: _signInAnonymously,
                child: Text('Continue as Guest'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF8B4513), // Woody brown color
                  foregroundColor: Colors.white,
                ),
              ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
