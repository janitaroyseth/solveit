import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:solveit/models/filter.dart';
import 'package:solveit/models/filter_option.dart';
import 'package:solveit/widgets/checkbox_list_item.dart';
import 'package:solveit/widgets/radio_button_group.dart';

/// Represents a modal for displaying filtering options.
class FilterModal extends StatefulWidget {
  /// [String] title displayed on top of the filter modal.
  final String modalTitle;

  /// [List<Filter>] list of filters for the filter modal.
  final List<Filter> filters;

  /// Creates an instance for filter modal with the given [String] modal title,
  /// and the given [List<Filter>] list of filters as options for filtering.
  const FilterModal({
    super.key,
    required this.modalTitle,
    required this.filters,
  });

  @override
  State<FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  /// Builds a [List] of filter options with the respective [FilterType].
  List<Widget> buildFilterOptionsDropDown(
    List<FilterOption> filterOptions,
    Filter filter,
  ) {
    List<Widget> filterOptionsDropDownList = [];

    if (filter.filterType == FilterType.sort) {
      filterOptionsDropDownList.add(RadioButtonGroup(filter: filter));
    }

    if (filter.filterType == FilterType.tag) {
      for (FilterOption filterOption in filterOptions) {
        filterOptionsDropDownList
            .add(CheckboxListItem(filterOption: filterOption, filter: filter));
      }
    }

    return filterOptionsDropDownList;
  }

  /// Builds filter options [ListTile] for displaying the options
  /// for filtering.
  List<Widget> buildFilterOptionListItems() {
    List<Widget> filterOptions = [];

    filterOptions.add(
      Text(widget.modalTitle.toLowerCase()),
    );

    for (var filter in widget.filters) {
      Widget listTile = ListTile(
        dense: false,
        title: Text(filter.title.toLowerCase()),
        trailing: GestureDetector(
          onTap: () {
            setState(() {
              filter.collapsed = !filter.collapsed;
            });
          },
          child: AnimatedRotation(
            turns: filter.collapsed ? 0 : 0.25,
            duration: const Duration(milliseconds: 150),
            child: const Icon(
              PhosphorIcons.caretRight,
              semanticLabel: "Show tags to filter the task list by",
            ),
          ),
        ),
      );
      filterOptions.add(listTile);
      filterOptions.add(const Divider(height: 1));
      setState(() {
        filterOptions.insert(
          filterOptions.indexOf(listTile) + 1,
          filter.collapsed
              ? const SizedBox(
                  height: 0,
                )
              : Column(
                  children: buildFilterOptionsDropDown(
                    filter.filterOptions,
                    filter,
                  ),
                ),
        );
      });
    }

    return filterOptions;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: buildFilterOptionListItems(),
        ),
      ),
    );
  }
}
