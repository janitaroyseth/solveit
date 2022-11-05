import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:project/models/tag.dart';

void main() {
  /// Tag class constructor tests
  test('Test correct construction of Tag with no parameters', () {
    Tag tag = Tag();
    expect(tag.text, "tag");
    expect(tag.color, "#FFFFFF");
  });
  test('Test correct construction of Tag with valid parameters', () {
    Tag tag = Tag(text: "text", color: "#00FF00");
    expect(tag.text, "text");
    expect(tag.color, "#00FF00");
  });
  test('Test correct construction of Tag with invalid parameters', () {
    Tag tag = Tag(text: "", color: "1234");
    expect(tag.text, "Invalid Text");
    expect(tag.color, "#FF0000");
  });
}
