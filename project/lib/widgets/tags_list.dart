import 'package:flutter/material.dart';
import 'package:project/widgets/tag.dart';

/// Represents a list containing [Tag].
class TagsList extends StatelessWidget {
  /// The [tags] in the [TagList].
  final List<Tag> tags;

  /// Creates an instance of tag list, where [tags] is the list of tags represented in the list.
  const TagsList({
    super.key,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: tags,
    );
  }
}
