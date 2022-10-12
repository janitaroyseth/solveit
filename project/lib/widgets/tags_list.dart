import 'package:flutter/material.dart';
import '../widgets/tag.dart';

/// Represents a list containing [Tag].
class TagsList extends StatelessWidget {
  /// The [tags] in the [TagList].
  final List<Widget> tags;
  final int numberOfColumns;

  /// Creates an instance of tag list, where [tags] is the list of tags represented in the list.
  const TagsList({
    super.key,
    required this.tags,
    this.numberOfColumns = 10
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 1.0, /// horizontal gap
      runSpacing: 1.0, /// vertical gap
      alignment: WrapAlignment.start,
      children: tags,
    );
  }
}
