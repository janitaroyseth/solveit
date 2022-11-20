class User {
  String username;
  String email;
  String? imageUrl;
  String bio;

  User({
    required this.username,
    required this.email,
    this.imageUrl,
    this.bio = "",
  });

  /// Converts a [Map] object to a [User]  object.
  static User? fromMap(Map<String, dynamic>? data) {
    if (data == null) {
      return null;
    }
    final String username = data["username"];
    final String email = data["email"];
    final String bio = data["bio"];
    String imageUrl = data["imageUrl"];

    return User(
      username: username,
      email: email,
      imageUrl: imageUrl,
      bio: bio,
    );
  }

  static Map<String, dynamic> toMap(User user) {
    return {
      "username": user.username,
      "email": user.email,
      "bio": user.bio,
      "imageUrl": user.imageUrl
    };
  }
}
