import 'package:flutter/material.dart';
import 'package:project/models/tag.dart';

/// Options for sizing of tags.
enum TagSize { small, large }

/// Represents a tag which descibes a task.
class TagWidget extends StatelessWidget {
  /// The [size] of the tag, of type enum [Size].
  final TagSize size;

  /// The [color] of the tag, of type [Color].
  final Color color;

  /// [tagText] is the text in the tag, of type [String].
  final String tagText;

  /// Creates an instance of [TagWidget].
  const TagWidget({
    super.key,
    required this.size,
    required this.color,
    required this.tagText,
  });

  TagWidget.fromTag(Tag tag, {super.key, this.size = TagSize.large})
      : tagText = tag.text,
        color = tag.color.length > 7
            ? Color(int.parse(tag.color.substring(1), radix: 16))
            : Color(
                int.parse(tag.color.substring(1), radix: 16) + 0xFF000000,
              );

  @override
  int get hashCode => color.hashCode + tagText.hashCode;

  @override
  bool operator ==(Object other) {
    return hashCode == other.hashCode;
  }

  @override
  Widget build(BuildContext context) {
    Color contrastColor =
        color.computeLuminance() * color.alpha.clamp(0, 1) < 0.45
            ? Colors.white
            : Colors.black;
    return size == TagSize.small
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1.2),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 3.0,
                vertical: 1.5,
              ),
              decoration: BoxDecoration(
                color: color,
                //border: Border.all(color: contrastColor, width: 0.5),
                borderRadius: const BorderRadius.all(
                  Radius.circular(50),
                ),
              ),
              child: Text(
                tagText,
                style: TextStyle(
                  color: contrastColor,
                  fontSize: 9.5,
                ),
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1.8),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 5.0,
                vertical: 3.5,
              ),
              decoration: BoxDecoration(
                color: color,
                //border: Border.all(color: contrastColor, width: 0.5),
                borderRadius: const BorderRadius.all(
                  Radius.circular(50),
                ),
              ),
              child: Text(
                tagText,
                style: TextStyle(
                  color: contrastColor,
                  fontSize: 12,
                ),
              ),
            ),
          );
  }
}
