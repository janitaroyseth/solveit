import 'package:flutter/material.dart';
import '../widgets/tag.dart';

/// Represents a list containing [Tag].
class TagsList extends StatelessWidget {
  /// The [tags] in the [TagList].
  final List<Tag> tags;
  final Size size;

  /// Creates an instance of tag list, where [tags] is the list of tags represented in the list.
  const TagsList({
    super.key,
    required this.tags,
    this.size = Size.small
  });

  @override
  Widget build(BuildContext context) {
    if (size == Size.large) {
      List<Tag> newTags = [];
      for (Tag tag in tags) {
        newTags.add(Tag(
          tagText: tag.tagText,
          size: Size.large,
          color: tag.color,
        ));
      }
      tags.clear();
      tags.addAll(newTags);
    }
    return Wrap(
      spacing: 1.0, /// horizontal gap
      runSpacing: 1.0, /// vertical gap
      alignment: WrapAlignment.start, /// How the children within a run should be placed in the main axis.
      children: tags,
    );
  }
}
