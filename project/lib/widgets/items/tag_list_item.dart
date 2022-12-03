import 'package:flutter/material.dart';
import 'package:project/models/tag.dart';
import 'package:project/utilities/color_utility.dart';

/// Options for sizing of tags.
enum TagSize { small, large }

/// Represents a tag which descibes a task.
class TagListItem extends StatelessWidget {
  /// The [size] of the tag, of type enum [Size].
  final TagSize size;

  /// The [color] of the tag, of type [Color].
  final Color color;

  /// [tagText] is the text in the tag, of type [String].
  final String tagText;

  /// Creates an instance of [TagListItem].
  const TagListItem({
    super.key,
    required this.size,
    required this.color,
    required this.tagText,
  });

  /// Creates an instance of [TagListItem] from the given [Tag], defaults to size large.
  TagListItem.fromTag(Tag tag, {super.key, this.size = TagSize.large})
      : tagText = tag.text,
        color = ColorUtility.colorFromString(tag.color);

  @override
  Widget build(BuildContext context) {
    return size == TagSize.small ? _smallTag() : _largeTag();
  }

  Padding _largeTag() {
    return Padding(
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
        child: tagText.isNotEmpty
            ? Text(
                tagText,
                style: TextStyle(
                  color: ColorUtility.getContrastColor(color),
                  fontSize: 12,
                ),
              )
            : const SizedBox(
                width: 50,
                height: 16,
              ),
      ),
    );
  }

  Padding _smallTag() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1.2),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 6.0,
          vertical: 3,
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
            color: ColorUtility.getContrastColor(color),
            fontSize: 10,
          ),
        ),
      ),
    );
  }
}
