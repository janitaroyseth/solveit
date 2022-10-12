import 'package:flutter/material.dart';
import 'package:project/models/filter_option.dart';

/// Represents a group of radio buttons.
class RadioButtonGroup extends StatefulWidget {
  /// The list of [FilterOption] this radio group represents.
  final List<FilterOption> filterOptions;

  /// Creates an instance of [RadioButtonGroup] from the given [List<FilterOption>].
  const RadioButtonGroup({
    super.key,
    required this.filterOptions,
  });

  @override
  State<RadioButtonGroup> createState() => _RadioButtonGroupState();
}

class _RadioButtonGroupState extends State<RadioButtonGroup> {
  FilterOption? chosenSort;

  @override
  void initState() {
    chosenSort = widget.filterOptions[0];
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
          filterOption.filterHandler!();
        },
      ),
    );
  }

  /// Returns a [List<Widget>] of radio buttons made from the given [List<FilterOption>].
  Widget buildRadioButtonGroup(List<FilterOption> filterOptions) {
    List<Widget> radiobuttons = [];

    for (FilterOption filterOption in filterOptions) {
      radiobuttons.add(
        Padding(
          padding: const EdgeInsets.only(left: 35.0),
          child: SizedBox(
            height: 36,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(child: filterOption.filterOption),
                buildRadioButton(filterOption),
              ],
            ),
          ),
        ),
      );
    }
    return Column(
      children: radiobuttons,
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildRadioButtonGroup(widget.filterOptions);
  }
}
