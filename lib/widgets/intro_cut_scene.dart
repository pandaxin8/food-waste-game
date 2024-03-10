import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:food_waste_game/main.dart';
import 'package:food_waste_game/models/character.dart';
import 'package:food_waste_game/models/story.dart';
import 'package:food_waste_game/widgets/speech_bubble.dart';



// Transparent image bytes
final Uint8List kTransparentImage = Uint8List.fromList([
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, // PNG signature
  0x00, 0x00, 0x00, 0x0D, // IHDR chunk length
  0x49, 0x48, 0x44, 0x52, // IHDR chunk type
  0x00, 0x00, 0x00, 0x01, // width: 1 pixel
  0x00, 0x00, 0x00, 0x01, // height: 1 pixel
  0x08, 0x06, 0x00, 0x00, 0x00, // bit depth, color type, compression, filter, interlace
  0x1F, 0x15, 0xC4, 0x89, // CRC
  0x00, 0x00, 0x00, 0x0A, // IDAT chunk length
  0x49, 0x44, 0x41, 0x54, // IDAT chunk type
  0x78, 0x9C, 0x63, 0x00, // zlib header
  0x01, 0x00, 0x00, 0x05, // compressed block with the pixel data
  0x00, 0x01, 0x0D, 0x0A, // actual pixel data (one transparent pixel)
  0x2D, 0xB4, // Adler-32 checksum
  0x00, 0x00, 0x00, 0x00, // IEND chunk length
  0x49, 0x45, 0x4E, 0x44, // IEND chunk type
  0xAE, 0x42, 0x60, 0x82, // CRC
]);

class IntroCutscene extends StatefulWidget {
  @override
  _IntroCutsceneState createState() => _IntroCutsceneState();
}

class _IntroCutsceneState extends State<IntroCutscene> {
  int _currentSegmentIndex = 0;
  int _currentImagePathIndex = 0;
  StorySegment? _currentSegment;
  List<StorySegment> _segments = [];
  Timer? _imagePathTimer;
  PageController _pageController = PageController(initialPage: 0);
  // Timer? _pageTimer;
  Timer? _segmentTimer;
  

  @override
  void initState() {
    super.initState();
    _loadStorySegments();
  }

void _startImagePathTimer() {
  _imagePathTimer = Timer.periodic(Duration(seconds: 3), (timer) {
    int nextIndex = _currentImagePathIndex + 1;
    if (_currentSegment != null && nextIndex < (_currentSegment!.imagePaths?.length ?? 0)) {
      setState(() {
        _currentImagePathIndex = nextIndex;
      });
    } else {
      _imagePathTimer?.cancel(); 
      // No automatic segment change here 
    }
  });
}

  void _nextSegment() {
    _imagePathTimer?.cancel(); 
    if (_currentSegmentIndex < _segments.length - 1) {
      _currentImagePathIndex = 0; // Reset Image Index
      _pageController.animateToPage(
        ++_currentSegmentIndex,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _startImagePathTimer(); // Start image cycling for the new segment 
    } else {
      // Navigate to the tutorial screen instead of the game screen
      Navigator.pushReplacementNamed(context, AppRoutes.tutorial);
    }
  }





  @override
Widget build(BuildContext context) {
  if (_segments.isEmpty) {
    // Show loading indicator while segments are being fetched
    return Scaffold(
      backgroundColor: Colors.green.shade200,
      body: Center(child: CircularProgressIndicator()),
    );
  } else {
    // Once the segments are loaded, use a PageView to display them
    return Scaffold(
      backgroundColor: Colors.green.shade200,
      body: PageView.builder(
        controller: _pageController,
        itemCount: _segments.length, // The number of segments you have
        itemBuilder: (context, index) {
          return _buildStorySegment(context, _segments[index]);
        },
      ),
    );
  }
}


  
 void _loadStorySegments() async {
  final storiesCollection = FirebaseFirestore.instance.collection('stories');
  final List<String> introStoryIds = [
    'introScene',
    'introGus',
    'restaurantWaste',
    'introductionToRestaurant',
    'gameplayMechanics',
    'emotionalEngagement',
    'conclusion'
  ];

  List<StorySegment> fetchedSegments = [];

  for (String storyId in introStoryIds) {
    final storyDoc = await storiesCollection.doc(storyId).get();
    print('storydoc: ${storyDoc.id}');
    print('storyDoc.exists: ${storyDoc.exists}');

    if (storyDoc.exists) {
      var data = storyDoc.data() as Map<String, dynamic>?; // Cast to a nullable Map<String, dynamic>

      if (data != null) {
        // Fetch the character document using the reference
        DocumentReference? characterRef = data['character'];
        Map<String, dynamic>? characterData;
        if (characterRef is DocumentReference) {
          DocumentSnapshot characterSnapshot = await characterRef.get();
          characterData = characterSnapshot.data() as Map<String, dynamic>?;
        }

        // Now you can create your character
        Character character;
        if (characterData != null) {
          character = Character.fromJson(characterData);
        } else {
          // Handle the null case, maybe with default character data
          character = Character(name: 'default_name', bio: 'default_bio', imagePaths: []);
        }

        // Create the new segment with the character
        final newSegment = StorySegment(
          id: data['id'] ?? 'default_id',
          text: data['text'] ?? 'default_text',
          character: character,
          imagePaths: (data['imagePaths'] as List?)?.map((item) => item as String).toList(),
          choices: (data['choices'] as List?)?.map((item) => item as String).toList(),
        );
        fetchedSegments.add(newSegment);
      }
    }
    // if (_currentSegment != null) {
    //   _startImagePathTimer(); // Start the timer for the first segment's image paths
    // }
    // Instead, you should start the image timer after the state has been set with the segments, if there's at least one segment.
    if (_segments.isNotEmpty) {
      _currentSegment = _segments.first;
      _startImagePathTimer();
    }
  }

  // _startAutoAdvanceTimer();

  setState(() {
    _segments = fetchedSegments;
    if (_segments.isNotEmpty) {
      _currentSegment = _segments.first;
      _currentImagePathIndex = 0;
      _startImagePathTimer(); // Ensure this is called to start the image transitions for the first segment.
    }
  });


  // if (_currentSegment != null) {
  //   // Start the cutscene with the first segment
  //   _nextSegment();
  // }
}



 Widget _buildStorySegment(BuildContext context, StorySegment segment) {
  // Optionally use a transparent image as a placeholder

  final transparentImage = MemoryImage(kTransparentImage); // Placeholder for FadeInImage

  // Create the main image widget with a fade-in effect
  Widget mainImageWidget = segment.imagePaths != null && segment.imagePaths!.isNotEmpty
      ? FadeInImage(
          placeholder: transparentImage,
          image: AssetImage(segment.imagePaths![_currentImagePathIndex % segment.imagePaths!.length]),
          fit: BoxFit.cover,
          fadeInDuration: Duration(milliseconds: 300),
          fadeOutDuration: Duration(milliseconds: 100),
          placeholderFit: BoxFit.cover,
        )
      : SizedBox(); // If no images, display an empty container

  // Create the character image widget if available
  Widget characterImageWidget = segment.character.imagePaths != null && segment.character.imagePaths!.isNotEmpty
      ? Image.asset(segment.character.imagePaths![0], width: MediaQuery.of(context).size.width * 0.2)
      : SizedBox(); // If no character image, display an empty container

  // Calculate the size of the character sprite
  double characterWidth = MediaQuery.of(context).size.width * 0.2;
  double characterHeight = characterWidth; // Assuming a square shape for simplicity

  // Calculate the bottom padding for the speech bubble
  double bottomPadding = characterImageWidget != SizedBox()
      ? MediaQuery.of(context).size.width * 0.2 + 32 // Image height + some padding
      : 32; // Default padding when no image

  return Stack(
    children: [
      // Main story image widget
      Positioned.fill(child: mainImageWidget),
      // Character sprite at the bottom left
      Positioned(
        left: 16,
        bottom: 16,
        child: characterImageWidget,
      ),
      // Speech bubble with the text to the right of the sprite
      Positioned(
        left: 16 + characterWidth + 8, // Sprite width plus some margin
        right: 16, // Ensure we have padding from the right side of the screen
        bottom: 16 + (characterHeight - 16) / 2, // Vertically center to sprite
        child: SpeechBubble(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              segment.text,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
          ),
        ),
      ),
      // Container for Continue and Skip buttons
      Positioned(
        right: 16,
        bottom: 16,
        child: Row(
          mainAxisSize: MainAxisSize.min, // To wrap the content of the row
          children: [
            // Skip button
            ElevatedButton(
              onPressed: () {
                _imagePathTimer?.cancel(); // Stop any running timers
                Navigator.pushReplacementNamed(context, AppRoutes.tutorial); // Change this to your desired route
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 102, 46, 42), // Color for the skip button
                foregroundColor: Colors.white, // Text color
              ),
              child: Text('Skip'),
            ),
            SizedBox(width: 8), // Spacing between Skip and Continue buttons
            // Continue button
            ElevatedButton(
              onPressed: _nextSegment,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF8D6E63), // Wood color button
                foregroundColor: Colors.white, // Text color
              ),
              child: Text('Continue'),
            ),
          ],
        ),
      ),
    ],
  );
}





Widget _buildChoices(List<String>? choices) {
  if (choices == null || choices.isEmpty) {
    return SizedBox.shrink(); // Returns an empty container if there are no choices
  }

  return Column(
    children: choices.map((choice) {
      return ElevatedButton(
        onPressed: () {
          // Handle choice selection
        },
        child: Text(choice),
      );
    }).toList(),
  );
}



  @override
  void dispose() {
    _imagePathTimer?.cancel(); // Cancel the image path timer
    // _segmentTimer?.cancel(); // Cancel the segment timer if it's set somewhere
    _pageController.dispose();
    super.dispose();
  }

  
}
