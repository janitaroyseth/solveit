class User {
  String firstname;
  String lastname;
  String email;
  String password;
  String imageUrl;
  String bio;

  User({
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.password,
    this.imageUrl = "assets/images/empty_profile_pic_large.png",
    this.bio = "",
  });

  /// Converts a [Map] object to a [User]  object.
  static User? fromMap(Map<String, dynamic>? data) {
    if (data == null) {
      return null;
    }
    final String firstname = data["firstname"];
    final String lastname = data["lastname"];
    final String email = data["email"];
    final String password = data["password"];
    final String bio = data["bio"];
    final String imageUrl = data["imageUrl"];

    return User(
      firstname: firstname,
      lastname: lastname,
      email: email,
      password: password,
      imageUrl: imageUrl,
      bio: bio,
    );
  }
}
