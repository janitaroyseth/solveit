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
    if (numberOfColumns == 1) {
      return Column(children: tags);
    } else if (numberOfColumns > tags.length) {
      return Row(children: tags);
    } else if (numberOfColumns > 0) {
      /// Split the tags into right number of rows.
      List<Widget> rows = [];
      for (var index = 0; index < tags.length;) {
        List<Widget> rowItems = [];
        for (var i = 0; i < numberOfColumns; i++) {
          if (index < tags.length) {
            rowItems.add(tags[index]);
            index++;
          } else {
            break;
          }
        }

        /// Convert the row into widget and add it to the final column data.
        Row row = Row(children: rowItems);
        rows.add(row);
      }
      return Column(children: rows);
    } else {
      throw RangeError("Number of columns cannot be lower than 1.");
    }
  }
}
