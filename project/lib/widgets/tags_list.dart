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
    List<Widget> addPaddingToTagsList() {
      for (int index = 0; index < tags.length; index++) {
        if (index % 2 == 0) {
          tags.insert(
            index,
            const SizedBox(
              width: 4,
            ),
          );
        }
      }
      return tags;
    }

    return Row(
      children: addPaddingToTagsList(),
    );
  }
}
