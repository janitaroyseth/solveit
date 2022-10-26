import 'package:solveit/models/filter_option.dart';

/// What type of filtering, sort or check.
enum FilterType { sort, tag }

/// Represents a filter option to filter and sort through lists.
class Filter {
  /// [bool] showing whether the filter is collapsed (hidden), or not (showing).
  bool collapsed;

  /// [String] title describing what the options of filtering or sorting is.
  final String title;

  /// [Function] function to be used for filtering or sorting, ignore if not needed.
  final Function? filterHandler;

  /// [List<FilterOption>] list of filterOptions to filter by.
  final List<FilterOption> filterOptions;

  ///[FilterType] which type of filter it is.
  final FilterType filterType;

  /// Creates an instance of [Filter] with the given title, filterHandler,
  /// filter options and filterType.
  Filter({
    this.collapsed = true,
    required this.title,
    required this.filterHandler,
    required this.filterOptions,
    required this.filterType,
  });
}
