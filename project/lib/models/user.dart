class User {
  String userId;
  String username;
  String email;
  String? imageUrl;
  String bio;

  User({
    this.userId = "",
    required String username,
    required String email,
    this.imageUrl,
    this.bio = "",
  })  : username = RegExp(r'^[a-zA-ZæøåÆØÅ\-. 1-12]{3,30}$').hasMatch(username)
            ? username
            : "invalid username",
        email = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(email)
            ? email
            : "invalid email";

  /// Converts a [Map] object to a [User]  object.
  static User? fromMap(Map<String, dynamic>? data) {
    if (data == null) {
      return null;
    }
    final String userId = data["userId"] ?? "";
    final String username = data["username"];
    final String email = data["email"];
    final String bio = data["bio"];
    String imageUrl = data["imageUrl"];

    return User(
      userId: userId,
      username: username,
      email: email,
      imageUrl: imageUrl,
      bio: bio,
    );
  }

  static List<User> fromMaps(var data) {
    List<User> users = [];
    for (var value in data) {
      User? user = fromMap(value);
      if (user != null) {
        users.add(user);
      }
    }
    return users;
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

  @override
  bool operator ==(Object other) {
    return userId == (other as User).userId;
  }

  @override
  int get hashCode => userId.hashCode;
}
