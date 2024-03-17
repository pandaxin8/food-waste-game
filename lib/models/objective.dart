import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class Objective with ChangeNotifier {
  final String id; // Add an 'id' property
  final String description;
  final String checkFunctionName; // name of check function in ObjectiveCheck
  //Map<String, dynamic> criteria;
  bool isCompleted;

  Objective({
    required this.id, 
    required this.description, 
    required this.checkFunctionName,
    //required this.criteria,
    this.isCompleted = false,
    }
  );

  static Objective fromDocument(DocumentSnapshot doc) {
    return Objective(
      id: doc.get('id') as String, // Get document ID
      description: doc.get('description') as String,
      checkFunctionName: doc.get('checkFunctionName') as String,
    //  criteria: doc.get('criteria') as Map<String, dynamic>,
      isCompleted: doc.get('isCompleted') as bool? ?? false
    );
  }

void complete() {
    isCompleted = true;
    notifyListeners();
  }
}