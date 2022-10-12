import 'package:flutter/material.dart';

/// Represents a filtering option for a filter.
class FilterOption {
  // TODO: temporarily there is a widget here, but to be fixed when other
  // models are up

  /// [Widget] the filter option to filter by.
  final Widget filterOption;

  ///[bool] whether the filter option is filtered by or not.
  bool filterBy;

  /// [Function] function to be used for filtering or sorting for this filteroption,
  /// ignore if not needed.
  final Function()? filterHandler;

  /// Creates an instance of [FilterOption] with the given filter option description
  FilterOption(
      {required this.filterOption, required this.filterBy, this.filterHandler});
}
