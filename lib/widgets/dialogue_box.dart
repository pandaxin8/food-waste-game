import 'package:flutter/material.dart';
import 'package:food_waste_game/models/story.dart';


class DialogueBox extends StatefulWidget {
  final StorySegment segment;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  DialogueBox({
    Key? key,
    required this.segment,
    required this.onNext,
    required this.onSkip,
  }) : super(key: key);

  @override
  _DialogueBoxState createState() => _DialogueBoxState();
}

class _DialogueBoxState extends State<DialogueBox> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.segment.text,  // Changed from widget.text to widget.segment.text
              style: Theme.of(context).textTheme.bodyText2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: widget.onSkip,
                  child: Text('Skip'),
                ),
                ElevatedButton(
                  onPressed: widget.onNext,
                  child: Text('Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


