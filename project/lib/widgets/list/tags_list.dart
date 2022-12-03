import 'package:flutter/material.dart';
import 'package:project/models/tag.dart' as model;
import 'package:project/widgets/items/tag_list_item.dart';

/// Represents a list containing [TagListItem].
class TagsList extends StatelessWidget {
  /// The [tags] in the [TagList].
  final List<model.Tag> tags;

  /// The [Size] of
  final TagSize size;

  /// Creates an instance of tag list, where [tags] is the list of tags represented in the list.
  const TagsList({
    super.key,
    this.size = TagSize.small,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Wrap(
            spacing: 2.0,
            runSpacing: 4.0,
            direction: Axis.horizontal,
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.start,
            children: tags
                .map(
                  (e) => TagListItem.fromTag(e, size: size),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
