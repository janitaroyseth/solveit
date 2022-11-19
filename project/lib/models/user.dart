class User {
  String userId;
  String username;
  String email;
  String imageUrl;
  String bio;

  User({
    required this.userId,
    required this.username,
    required this.email,
    this.imageUrl = "assets/images/empty_profile_pic_large.png",
    this.bio = "",
  });

  /// Converts a [Map] object to a [User]  object.
  static User? fromMap(Map<String, dynamic>? data) {
    if (data == null) {
      return null;
    }
    final String userId = data["userId"];
    final String username = data["username"];
    final String email = data["email"];
    final String bio = data["bio"];
    final String imageUrl = data["imageUrl"];

    return User(
      userId: userId,
      username: username,
      email: email,
      imageUrl: imageUrl,
      bio: bio,
    );
  }

  static Map<String, dynamic> toMap(User user) {
    return {
      "userId": user.userId,
      "username": user.username,
      "email": user.email,
      "bio": user.bio,
      "imageUrl": user.imageUrl
    };
  }
}
