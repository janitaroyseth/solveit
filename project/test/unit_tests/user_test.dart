import 'package:flutter_test/flutter_test.dart';
import 'package:project/models/user.dart';

void main() {
  /// User class unit tests
  test('Test correct construction of User with valid parameters', () {
    User user = User(username: "bob", email: "bob@geldof.ru");
    expect(user.userId, "");
    expect(user.username, "bob");
    expect(user.email, "bob@geldof.ru");

    user = User(
        username: "bob",
        email: "bob@geldof.ru",
        imageUrl: "someurl",
        bio: "i am a user.");
    expect(user.userId, "");
    expect(user.username, "bob");
    expect(user.email, "bob@geldof.ru");

    Map map = User.toMap(user);
    expect(map.keys.length, 5);
    expect(map["userId"], "");
    expect(map["username"], "bob");
    expect(map["email"], "bob@geldof.ru");
    expect(map["imageUrl"], "someurl");
    expect(map["bio"], "i am a user.");
  });

  /// User class unit tests
  test('Test correct construction of User with valid parameters', () {
    User user = User(username: "bob", email: "bob@geldof.ru");
    expect(user.userId, "");
    expect(user.username, "bob");
    expect(user.email, "bob@geldof.ru");

    user = User(
        username: "bob",
        email: "bob@geldof.ru",
        imageUrl: "someurl",
        bio: "i am a user.");
    expect(user.userId, "");
    expect(user.username, "bob");
    expect(user.email, "bob@geldof.ru");

    Map map = User.toMap(user);
    expect(map.keys.length, 5);
    expect(map["userId"], "");
    expect(map["username"], "bob");
    expect(map["email"], "bob@geldof.ru");
    expect(map["imageUrl"], "someurl");
    expect(map["bio"], "i am a user.");
  });

  test('Test correct construction of User with invalid parameters', () {
    try {
      User(username: "", email: "");
    } on ArgumentError catch (e) {
      expect(e.message, "username is not a valid format");
      return;
    }

    try {
      User(username: "Valid name", email: "");
    } on ArgumentError catch (e) {
      expect(e.message, "email is not a valid format");
      return;
    }

    try {
      User(username: "@12345", email: "not an email");
    } on ArgumentError catch (e) {
      expect(e.message, "username is not a valid format");
      return;
    }

    try {
      User(username: "Valid name", email: "not an email");
    } on ArgumentError catch (e) {
      expect(e.message, "email is not a valid format");
      return;
    }

    try {
      User(
          username: "this username is far too long to fit in a widget",
          email: "phony@email.invalid");
    } on ArgumentError catch (e) {
      expect(e.message, "username is not a valid format");
      return;
    }

    try {
      User(username: "Valid name", email: "phony@email.invalid");
    } on ArgumentError catch (e) {
      expect(e.message, "email is not a valid format");
      return;
    }
  });
}
