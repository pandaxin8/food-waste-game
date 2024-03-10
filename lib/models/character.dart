class Character {
  String name;
  String bio;
  List<String>? imagePaths; // Changed to nullable List<String>
  Map<String, dynamic> attributes;

  Character({
    required this.name,
    required this.bio,
    this.imagePaths, // Removed the required keyword
    this.attributes = const {},
  });

  // Create a `fromJson` constructor
  factory Character.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw ArgumentError('The json must not be null'); // You can handle this more gracefully if needed
    }
    // Ensure the imagePaths JSON is a list if it exists, or default to null
    List<String>? paths = json['imagePaths'] != null ? List<String>.from(json['imagePaths'] as List) : null;

    return Character(
      name: json['name'] as String? ?? 'default_name',
      bio: json['bio'] as String? ?? 'default_bio',
      imagePaths: paths, // Use the nullable paths
      attributes: json['attributes'] as Map<String, dynamic>? ?? {},
    );
  }

  // Additional methods for character behaviors...

  // Convert back to a map
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'bio': bio,
      'imagePaths': imagePaths, // Save it as it is, which can be a List<String> or null
      'attributes': attributes,
    };
  }
}
