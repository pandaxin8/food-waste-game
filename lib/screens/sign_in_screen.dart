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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signInWithEmailAndPassword,
              child: Text('Sign In'),
            ),
          ],
        ),
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
