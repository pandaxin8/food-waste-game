import 'package:flutter/material.dart';
import 'package:food_waste_game/models/story.dart';
import 'package:food_waste_game/widgets/dialogue_box.dart';


class NarrativeController extends StatefulWidget {
  @override
  _NarrativeControllerState createState() => _NarrativeControllerState();
}

class _NarrativeControllerState extends State<NarrativeController> {
  int currentIndex = 0;
  List<StorySegment> storySegments = []; // Initialize with your story data
  
  void nextSegment() {
    if (currentIndex < storySegments.length - 1) {
      setState(() {
        currentIndex++;
      });
    } else {
      // End of narrative logic
    }
  }
  
  void skipStory() {
    // Logic to skip to the end or a specific part of the story
  }

  @override
  Widget build(BuildContext context) {
    return DialogueBox(
      segment: storySegments[currentIndex],
      onNext: nextSegment,
      onSkip: skipStory,
    );
  }
}