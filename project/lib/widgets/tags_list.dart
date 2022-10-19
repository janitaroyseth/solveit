import 'package:flutter/material.dart';
import '../widgets/tag.dart';

/// Represents a list containing [Tag].
class TagsList extends StatelessWidget {
  /// The [tags] in the [TagList].
  final List<Widget> tags;

  /// Creates an instance of tag list, where [tags] is the list of tags represented in the list.
  const TagsList({
    super.key,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 1.0,
      runSpacing: 1.0,
      alignment: WrapAlignment.start,
      children: tags,
    );
  }
}
