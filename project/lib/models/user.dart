/// Represents a user.
class User {
  /// The id of the user.
  String userId;

  /// The displayed name of the user.
  String username;

  /// The email of this user.
  String email;

  /// The url of the image of the user.
  String? imageUrl;

  /// A short description of the user.
  String bio;

  /// Creates an instance of [User].
  User({
    this.userId = "",
    required this.username,
    required this.email,
    this.imageUrl,
    this.bio = "",
  }) {
    if (!RegExp(r'^[a-zA-ZæøåÆØÅ\-. 1-12]{3,30}$').hasMatch(username)) {
      throw ArgumentError("username is not a valid format");
    }

    if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(email)) {
      throw ArgumentError("email is not a valid format");
    }
  }

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

  /// Creates a list of user from the given maps.
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

  /// Converts the given user object to a map of string and dynamic.
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
