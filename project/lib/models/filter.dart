import 'package:project/models/filter_option.dart';

/// What type of filtering, sort or check.
enum FilterType { sort, check }

/// Reptresents a filter option to filter and sort through lists.
class Filter {
  /// [bool] showing whether the filter is collapsed (hidden), or not (showing).
  bool collapsed;

  /// [String] title describing what the options of filtering or sorting is.
  final String title;

  /// [Function] function to be used for filtering or sorting, ignore if not needed.
  final Function(Filter filter)? filterHandler;

  /// [List<FilterOption>] list of filteroptions to filter by.
  List<FilterOption> filterOptions;

  /// [FilterType] enum describing which type of filtering this is.
  final FilterType filterType;

  /// Creates an instance of [Filter] with the given title, filterhandler,
  /// filter options and filtertype.
  Filter({
    this.collapsed = true,
    required this.title,
    required this.filterHandler,
    required this.filterOptions,
    required this.filterType,
  });
}
