class Character {
  String name;
  String bio;
  String imagePath;
  Map<String, dynamic> attributes;

  Character({
    required this.name,
    required this.bio,
    required this.imagePath,
    this.attributes = const {},
  });

  // Additional methods for character behaviors...
  
}
