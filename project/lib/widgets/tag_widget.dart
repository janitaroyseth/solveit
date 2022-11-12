import 'package:flutter/material.dart';
import 'package:project/models/tag.dart';

/// Options for sizing of tags.
enum Size { small, large }

/// Represents a tag which descibes a task.
class TagWidget extends StatelessWidget {
  /// The [size] of the tag, of type enum [Size].
  final Size size;

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

  TagWidget.fromTag(Tag tag, {super.key, this.size = Size.large})
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
    return size == Size.small
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1.2),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50.0),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 3.0,
                  vertical: 1.5,
                ),
                decoration: BoxDecoration(
                  color: color,
                ),
                child: Text(
                  tagText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9.5,
                  ),
                ),
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1.8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50.0),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 5.0,
                  vertical: 3.5,
                ),
                decoration: BoxDecoration(
                  color: color,
                ),
                child: Text(
                  tagText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          );
  }
}
