import 'package:cloud_firestore/cloud_firestore.dart';

class Player {
  String id; // Unique ID, tied to Firebase Auth user ID
  int currentLevel;
  int points;
  List<String> unlockedDishes; // List of dish IDs or names
  List<String> achievements; // List of achievement IDs or names


  Player({
    required this.id,
    this.currentLevel = 1,
    this.points = 0,
    List<String>? unlockedDishes,
    List<String>? achievements,
  })  : this.unlockedDishes = unlockedDishes ?? [],
        this.achievements = achievements ?? [];

  // Create a Player object from a Firestore document
  factory Player.fromDocument(DocumentSnapshot doc) {
    return Player(
      id: doc.id,
      currentLevel: doc.get('currentLevel') as int,
      points: doc.get('points') as int,
      unlockedDishes: List<String>.from(doc.get('unlockedDishes')),
      achievements: List<String>.from(doc.get('achievements')),
    );
  }

  // Convert a Player object into a Map for Firestore updates
  Map<String, dynamic> toMap() {
    return {
      'currentLevel': currentLevel,
      'points': points,
      'unlockedDishes': unlockedDishes,
      'achievements': achievements,
    };
  }
}
