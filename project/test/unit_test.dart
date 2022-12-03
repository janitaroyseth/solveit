import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:project/models/tag.dart';
import 'package:project/models/user.dart';

void main() {
  bool isColor(String color) {
    return RegExp(r'^#([0-9a-fA-F]{6}||[0-9a-fA-F]{8})$').hasMatch(color);
  }

  /// Tag class constructor tests
  test('Test correct construction of Tag with no parameters', () {
    Tag tag = Tag();
    expect(tag.text, "tag");
    expect(isColor(tag.color), true);
  });
  test('Test correct construction of Tag with valid parameters', () {
    Tag tag = Tag(text: "text", color: "#00FF00");
    expect(tag.text, "text");
    expect(isColor(tag.color), true);
  });
  test('Test correct construction of Tag with invalid parameters', () {
    Tag tag = Tag(text: "", color: "1234");
    expect(tag.text, "invalid text");
    expect(isColor(tag.color), true);
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
    User user = User(username: "", email: "");
    expect(user.userId, "");
    expect(user.username, "invalid username");
    expect(user.email, "invalid email");

    user = User(username: "@12345", email: "not an email");
    expect(user.userId, "");
    expect(user.username, "invalid username");
    expect(user.email, "invalid email");

    user = User(
        username: "this username is far too long to fit in a widget",
        email: "phony@email.invalid");
    expect(user.userId, "");
    expect(user.username, "invalid username");
    expect(user.email, "invalid email");
  });
}
