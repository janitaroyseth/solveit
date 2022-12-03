import 'package:flutter/material.dart';
import 'package:project/utilities/filter_option.dart';

import '../utilities/filter.dart';

/// Represents a group of radio buttons.
class RadioButtonGroup extends StatefulWidget {
  /// The list of [FilterOption] this radio group represents.
  final Filter filter;

  /// The intial value of the radio button group.
  final FilterOption? initalValue;

  /// Creates an instance of [RadioButtonGroup] from the given [List<FilterOption>].
  const RadioButtonGroup({
    super.key,
    required this.filter,
    this.initalValue,
  });

  @override
  State<RadioButtonGroup> createState() => _RadioButtonGroupState();
}

class _RadioButtonGroupState extends State<RadioButtonGroup> {
  FilterOption? chosenSort;

  @override
  void initState() {
    chosenSort = widget.initalValue ?? widget.filter.filterOptions[0];
    super.initState();
  }

  /// Builds a radio button from the given [FilterOption] filter option using
  /// the given [FilterOption] group value for the radio buttons.
  Widget buildRadioButton(FilterOption filterOption) {
    return Radio<FilterOption>(
      value: filterOption,
      groupValue: chosenSort,
      onChanged: (value) => setState(
        () {
          chosenSort = value;
          widget.filter.filterHandler!(filterOption);
        },
      ),
    );
  }

  /// Returns a [List<Widget>] of radio buttons made from the given [List<FilterOption>].
  Widget buildRadioButtonGroup(Filter filter) {
    List<Widget> radioButtons = [];

    for (FilterOption filterOption in filter.filterOptions) {
      radioButtons.add(
        Padding(
          padding: const EdgeInsets.only(left: 35.0),
          child: SizedBox(
            height: 36,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(child: Text(filterOption.description)),
                buildRadioButton(filterOption),
              ],
            ),
          ),
        ),
      );
    }
    return Column(
      children: radioButtons,
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildRadioButtonGroup(widget.filter);
  }
}
