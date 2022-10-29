import 'package:flutter/material.dart';
import 'package:project/models/filter.dart';
import 'package:project/models/filter_option.dart';
import 'package:project/widgets/tag_widget.dart';

/// Represents a list item with a checkbox for filtering through lists.
class CheckboxListItem extends StatefulWidget {
  /// [Filter] this checkmark will filter for.
  final Filter filter;

  /// [FilterOption] this checkmark list tile is built for.
  final FilterOption filterOption;

  /// Creates an instance of [CheckboxListItem] with the given [Filter] and
  /// [FilterOption].
  const CheckboxListItem({
    super.key,
    required this.filter,
    required this.filterOption,
  });

  @override
  State<CheckboxListItem> createState() => _CheckboxListItemState();
}

class _CheckboxListItemState extends State<CheckboxListItem> {
  /// Builds a checkmark from the given [FilterOption] filter option.
  Widget buildCheckMark(FilterOption filterOption, Filter filter) {
    return Checkbox(
      activeColor: Theme.of(context).primaryColor,
      shape: const CircleBorder(),
      value: filterOption.filterBy,
      onChanged: (value) {
        setState(() {
          filterOption.filterBy = value!;
          filter.filterHandler!(filter);
        });
      },
    );
  }

  /// Builds a list tile with a checkmark for filtering with the given [FilterOption]
  /// of the given [Filter].
  Widget buildCheckBoxListTile(FilterOption filterOption, Filter filter) {
    return Padding(
      padding: const EdgeInsets.only(left: 35.0),
      child: SizedBox(
        height: 36,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(child: TagWidget.fromTag(widget.filterOption.tag!)),
            buildCheckMark(filterOption, filter),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildCheckBoxListTile(widget.filterOption, widget.filter);
  }
}
