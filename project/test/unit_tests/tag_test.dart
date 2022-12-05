import 'package:flutter_test/flutter_test.dart';
import 'package:project/models/tag.dart';

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
}
